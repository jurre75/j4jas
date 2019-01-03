@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
IF EXIST "%~dp0perl.exe" (
"%~dp0perl.exe" -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
) ELSE IF EXIST "%~dp0..\..\bin\perl.exe" (
"%~dp0..\..\bin\perl.exe" -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
) ELSE (
perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
)

goto endofperl
:WinNT
IF EXIST "%~dp0perl.exe" (
"%~dp0perl.exe" -x -S %0 %*
) ELSE IF EXIST "%~dp0..\..\bin\perl.exe" (
"%~dp0..\..\bin\perl.exe" -x -S %0 %*
) ELSE (
perl -x -S %0 %*
)

if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';
#!perl
#line 29
use Mojo::Base -strict;

use File::Basename qw(dirname);
BEGIN { $ENV{PATH} = dirname($^X) . ";$ENV{PATH}" }

use Mojo::Server::Elzar;
use Mojo::Util qw(extract_usage getopt);

$ENV{MOJO_REUSE} = '';

getopt
  'c|command=s'      => \$ENV{ELZAR_COMMAND},
  'h|help'           => \my $help,
  'i|install=s'      => \$ENV{ELZAR_SVC_INST},
  'r|run_as_service' => \$ENV{ELZAR_SVC_RUN},
  's|stop'           => \$ENV{ELZAR_STOP},
  't|test'           => \$ENV{ELZAR_TEST};

die extract_usage if $help || !(my $app = shift || $ENV{ELZAR_APP});
Mojo::Server::Elzar->new->run($app);

=encoding utf8

=head1 NAME

elzar - Elzar HTTP and WebSocket server

=head1 SYNOPSIS

  Usage: elzar [OPTIONS] [APPLICATION]

    elzar ./script/my_app
    elzar ./myapp.pl
    elzar -f ./myapp.pl

  Options:
    -c, --command <command>  Send command to running server
                               available commands:
                                 "KILL"
                                 "QUIT"
                                 "WORKERS <n>"
                                 "WORKER KILL|QUIT <n>"
    -h, --help            Show this message
    -i, --install <name>  Install as Windows service
    -r, --run_as_service  Run as Windows service
                          do not run this from the command line,
                          this is used by the service manager
    -s, --stop            Stop server gracefully
    -t, --test            Test application and exit

=head1 DESCRIPTION

Start L<Mojolicious> and L<Mojolicious::Lite> applications with the
L<Elzar|Mojo::Server::Elzar> web server.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<https://mojolicious.org>.

=cut

__END__
:endofperl
