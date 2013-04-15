package Libfreenect;

use 5.010001;
use strict;
use warnings;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Libfreenect ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	FREENECT_COUNTS_PER_G
	FREENECT_DEPTH_10BIT
	FREENECT_DEPTH_10BIT_PACKED
	FREENECT_DEPTH_10BIT_PACKED_SIZE
	FREENECT_DEPTH_10BIT_SIZE
	FREENECT_DEPTH_11BIT
	FREENECT_DEPTH_11BIT_PACKED
	FREENECT_DEPTH_11BIT_PACKED_SIZE
	FREENECT_DEPTH_11BIT_SIZE
	FREENECT_FRAME_H
	FREENECT_FRAME_PIX
	FREENECT_FRAME_W
	FREENECT_IR_FRAME_H
	FREENECT_IR_FRAME_PIX
	FREENECT_IR_FRAME_W
	FREENECT_LOG_DEBUG
	FREENECT_LOG_ERROR
	FREENECT_LOG_FATAL
	FREENECT_LOG_FLOOD
	FREENECT_LOG_INFO
	FREENECT_LOG_NOTICE
	FREENECT_LOG_SPEW
	FREENECT_LOG_WARNING
	FREENECT_VIDEO_BAYER
	FREENECT_VIDEO_BAYER_SIZE
	FREENECT_VIDEO_IR_10BIT
	FREENECT_VIDEO_IR_10BIT_PACKED
	FREENECT_VIDEO_IR_10BIT_PACKED_SIZE
	FREENECT_VIDEO_IR_10BIT_SIZE
	FREENECT_VIDEO_IR_8BIT
	FREENECT_VIDEO_IR_8BIT_SIZE
	FREENECT_VIDEO_RGB
	FREENECT_VIDEO_RGB_SIZE
	FREENECT_VIDEO_YUV_RAW
	FREENECT_VIDEO_YUV_RAW_SIZE
	FREENECT_VIDEO_YUV_RGB
	FREENECT_VIDEO_YUV_RGB_SIZE
	LED_BLINK_GREEN
	LED_BLINK_RED_YELLOW
	LED_BLINK_YELLOW
	LED_GREEN
	LED_OFF
	LED_RED
	LED_YELLOW
	TILT_STATUS_LIMIT
	TILT_STATUS_MOVING
	TILT_STATUS_STOPPED
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	FREENECT_COUNTS_PER_G
	FREENECT_DEPTH_10BIT
	FREENECT_DEPTH_10BIT_PACKED
	FREENECT_DEPTH_10BIT_PACKED_SIZE
	FREENECT_DEPTH_10BIT_SIZE
	FREENECT_DEPTH_11BIT
	FREENECT_DEPTH_11BIT_PACKED
	FREENECT_DEPTH_11BIT_PACKED_SIZE
	FREENECT_DEPTH_11BIT_SIZE
	FREENECT_FRAME_H
	FREENECT_FRAME_PIX
	FREENECT_FRAME_W
	FREENECT_IR_FRAME_H
	FREENECT_IR_FRAME_PIX
	FREENECT_IR_FRAME_W
	FREENECT_LOG_DEBUG
	FREENECT_LOG_ERROR
	FREENECT_LOG_FATAL
	FREENECT_LOG_FLOOD
	FREENECT_LOG_INFO
	FREENECT_LOG_NOTICE
	FREENECT_LOG_SPEW
	FREENECT_LOG_WARNING
	FREENECT_VIDEO_BAYER
	FREENECT_VIDEO_BAYER_SIZE
	FREENECT_VIDEO_IR_10BIT
	FREENECT_VIDEO_IR_10BIT_PACKED
	FREENECT_VIDEO_IR_10BIT_PACKED_SIZE
	FREENECT_VIDEO_IR_10BIT_SIZE
	FREENECT_VIDEO_IR_8BIT
	FREENECT_VIDEO_IR_8BIT_SIZE
	FREENECT_VIDEO_RGB
	FREENECT_VIDEO_RGB_SIZE
	FREENECT_VIDEO_YUV_RAW
	FREENECT_VIDEO_YUV_RAW_SIZE
	FREENECT_VIDEO_YUV_RGB
	FREENECT_VIDEO_YUV_RGB_SIZE
	LED_BLINK_GREEN
	LED_BLINK_RED_YELLOW
	LED_BLINK_YELLOW
	LED_GREEN
	LED_OFF
	LED_RED
	LED_YELLOW
	TILT_STATUS_LIMIT
	TILT_STATUS_MOVING
	TILT_STATUS_STOPPED
);

our $VERSION = '0.01';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&Libfreenect::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
#XXX	if ($] >= 5.00561) {
#XXX	    *$AUTOLOAD = sub () { $val };
#XXX	}
#XXX	else {
	    *$AUTOLOAD = sub { $val };
#XXX	}
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('Libfreenect', $VERSION);

# Preloaded methods go here.

sub new {
  my ( $proto, $args ) = @_;
  my $class = ref $proto || $proto;

  my $f_ctx = Libfreenect::init();
  die "*** Could not init!\n" if $f_ctx <= 0;
  return bless {
    f_ctx => $f_ctx
  }, $class;
}

sub shutdown {
  my $self = shift;
  return Libfreenect::shutdown( $self->{f_ctx} );
}

sub set_log_level {
  my $self = shift;
  my $log_level = shift;
  Libfreenect::_set_log_level( $self->{f_ctx}, $log_level );
}

sub num_devices {
  my $self = shift;
  return Libfreenect::_num_devices( $self->{f_ctx} );
}

sub open_device {
  my $self = shift;
  my $device_number = shift;
  my $ret_val = Libfreenect::_open_device( $self->{f_ctx}, $device_number );
  if ( $ret_val < 0 ) {
    die "*** Could not open device $device_number!\n";
  }
  $self->{f_dev} = $ret_val;
}

sub close_device {
  my $self = shift;
  my $ret_val = Libfreenect::_close_device( $self->{f_dev} );
  if ( $ret_val < 0 ) {
    die "*** Could not close device!\n";
  }
  $self->{f_dev} = undef;
}

sub set_led {
  my $self = shift;
  my $option = shift;
  Libfreenect::_set_led( $self->{f_dev}, $option );
}

sub process_events {
  my $self = shift;
  return Libfreenect::_process_events( $self->{f_ctx} );
}

sub start_depth {
  my $self = shift;
  return Libfreenect::_start_depth( $self->{f_dev} );
}

sub stop_depth {
  my $self = shift;
  return Libfreenect::_stop_depth( $self->{f_dev} );
}

sub start_video {
  my $self = shift;
  return Libfreenect::_start_video( $self->{f_dev} );
}

sub stop_video {
  my $self = shift;
  return Libfreenect::_stop_video( $self->{f_dev} );
}

sub update_tilt_state {
  my $self = shift;
  return Libfreenect::_update_tilt_state( $self->{f_dev} );
}

sub get_tilt_state {
  my $self = shift;
  return Libfreenect::_get_tilt_state( $self->{f_dev} );
}

sub get_mks_accel {
  my $self = shift;
  return Libfreenect::_get_mks_accel( $self->{f_dev} );
}

sub get_user {
  my $self = shift;
  return Libfreenect::_get_user( $self->{f_dev} );
}

sub set_user {
  my $self = shift;
  my $user = shift;
  Libfreenect::_set_user( $self->{f_dev}, $user );
}

sub set_depth_mode {
  my $self = shift;
  my $fmt = shift;
  return Libfreenect::_set_depth_mode( $self->{f_dev}, $fmt );
}

sub set_video_mode {
  my $self = shift;
  my $fmt = shift;
  return Libfreenect::_set_video_mode( $self->{f_dev}, $fmt );
}

sub set_depth_buffer {
  my $self = shift;
  my $buf = shift;
  return Libfreenect::_set_depth_buffer( $self->{f_dev}, $buf );
}

sub set_video_buffer {
  my $self = shift;
  my $buf = shift;
  return Libfreenect::_set_video_buffer( $self->{f_dev}, $buf );
}

sub set_tilt_degs {
  my $self = shift;
  my $angle = shift;
  return Libfreenect::_set_tilt_degs( $self->{f_dev}, $angle );
}

sub malloc_buffer {
  my $self = shift;
  my $size = shift;
  return Libfreenect::_malloc_buffer( $size );
}

sub free_buffer {
  my $self = shift;
  my $buffer = shift;
  Libfreenect::_free_buffer( $buffer );
}

sub get_buffer_value {
  my $self = shift;
  my $buffer = shift;
  my $idx = shift;
  return Libfreenect::_get_buffer_value( $buffer, $idx );
}

sub set_log_callback {
  my $self = shift;
  my $callback = shift;
  Libfreenect::_set_log_callback( $self->{f_ctx}, $callback );
}

sub set_my_callbacks {
  my $self = shift;
  Libfreenect::_set_my_callbacks( $self->{f_ctx}, $self->{f_dev} );
}

1;
__END__

=head1 NAME

Libfreenect - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Libfreenect;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Libfreenect, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.

=head2 Exportable constants

  FREENECT_COUNTS_PER_G
  FREENECT_DEPTH_10BIT
  FREENECT_DEPTH_10BIT_PACKED
  FREENECT_DEPTH_10BIT_PACKED_SIZE
  FREENECT_DEPTH_10BIT_SIZE
  FREENECT_DEPTH_11BIT
  FREENECT_DEPTH_11BIT_PACKED
  FREENECT_DEPTH_11BIT_PACKED_SIZE
  FREENECT_DEPTH_11BIT_SIZE
  FREENECT_FRAME_H
  FREENECT_FRAME_PIX
  FREENECT_FRAME_W
  FREENECT_IR_FRAME_H
  FREENECT_IR_FRAME_PIX
  FREENECT_IR_FRAME_W
  FREENECT_LOG_DEBUG
  FREENECT_LOG_ERROR
  FREENECT_LOG_FATAL
  FREENECT_LOG_FLOOD
  FREENECT_LOG_INFO
  FREENECT_LOG_NOTICE
  FREENECT_LOG_SPEW
  FREENECT_LOG_WARNING
  FREENECT_VIDEO_BAYER
  FREENECT_VIDEO_BAYER_SIZE
  FREENECT_VIDEO_IR_10BIT
  FREENECT_VIDEO_IR_10BIT_PACKED
  FREENECT_VIDEO_IR_10BIT_PACKED_SIZE
  FREENECT_VIDEO_IR_10BIT_SIZE
  FREENECT_VIDEO_IR_8BIT
  FREENECT_VIDEO_IR_8BIT_SIZE
  FREENECT_VIDEO_RGB
  FREENECT_VIDEO_RGB_SIZE
  FREENECT_VIDEO_YUV_RAW
  FREENECT_VIDEO_YUV_RAW_SIZE
  FREENECT_VIDEO_YUV_RGB
  FREENECT_VIDEO_YUV_RGB_SIZE
  LED_BLINK_GREEN
  LED_BLINK_RED_YELLOW
  LED_BLINK_YELLOW
  LED_GREEN
  LED_OFF
  LED_RED
  LED_YELLOW
  TILT_STATUS_LIMIT
  TILT_STATUS_MOVING
  TILT_STATUS_STOPPED

=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Jeff, E<lt>jgoff@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Jeff

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.

=cut
