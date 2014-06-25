package Data::Section::Fixture;
use 5.008005;
use strict;
use warnings;
use Data::Section::Simple;
use Scope::Guard;
use base qw(Exporter);

our $VERSION = "0.01";

our @EXPORT_OK = qw(with_fixture);

sub with_fixture ($&) {
    my ($dbh, $code) = @_;

    my ($pkg) = caller;
    my $reader = Data::Section::Simple->new($pkg);
    my $setup_sqls = $reader->get_data_section('setup') || '';
    my $teardown_sqls = $reader->get_data_section('teardown') || '';

    my $guard = Scope::Guard->new(sub {
        _exec_sqls($dbh, $teardown_sqls);
    });
    _exec_sqls($dbh, $setup_sqls);

    $code->();
}

sub _exec_sqls {
    my ($dbh, $sqls) = @_;
    for (split ';', $sqls) {
        $dbh->do($_) unless $_ =~ /^\s+$/;
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Data::Section::Fixture - It's new $module

=head1 SYNOPSIS

    use Data::Section::Fixture;

=head1 DESCRIPTION

Data::Section::Fixture is ...

=head1 LICENSE

Copyright (C) Yuuki Furuyama.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Yuuki Furuyama E<lt>addsict@gmail.comE<gt>

=cut

