package Tk::ListboxDnD;


=for

    ListboxDnD - A Tk::Listbox widget with drag and drop capability.
    Copyright (C) 2002  Greg London

    This program is free software; you can redistribute it and/or modify
    it under the same terms as Perl 5 itself.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    Perl 5 License schemes for more details.

    contact the author via http://www.greglondon.com

=cut


use strict;
use warnings;

use vars qw($VERSION);
$VERSION = '1.100';

use base  qw(Tk::Derived Tk::Listbox);
use Tk::widgets qw(Listbox );

Construct Tk::Widget 'ListboxDnD';

sub Populate
  {
    require Tk::Listbox;

    my($listbox, $args) = @_;

    my $format = delete($args->{'-dragFormat'});
    if(defined($format))
      {
	$listbox->{'ListboxDnD::dragFormat'} = $format;
      }
    else
      {
	$listbox->{'ListboxDnD::dragFormat'} = "<- %s ";
      }

    $listbox->SUPER::Populate($args);

    $listbox->Advertise('listbox' => $listbox );
    $listbox->ConfigSpecs(DEFAULT => [$listbox]);
    $listbox->Delegates(DEFAULT => $listbox);

    ########################################################
    # use button  3 to drag and drop the order of selected entries.
    ########################################################

    my $dragging_text;

    my $moving_callback = sub {return};
    my $marker_index;
    my $marker_text;

    # pressing button 3 selects the nearest element
    $listbox->bind
      (       '<ButtonPress-3>' => 
	      sub
	      { 
		$marker_index = $listbox->nearest($Tk::event->y);
		$dragging_text = $listbox->get($marker_index);
		$marker_text = sprintf( $listbox->{'ListboxDnD::dragFormat'}, $dragging_text );
		$listbox->delete($marker_index);
		$listbox->insert($marker_index, $marker_text);
		
		$moving_callback = sub 
		  {
		    my $current_index = $listbox->nearest($Tk::event->y);
		    return if ($current_index==$marker_index);
		
		    $listbox->delete($marker_index);
		    $listbox->insert($current_index, $marker_text);
		    $marker_index = $current_index;
		
		  };
	      }
      );

    # moving mouse while pressing button 3 shows where item will go
    $listbox->bind( '<Motion>' => sub { &$moving_callback; } );

    # releasing button 3 inserts the moving selection to the current index
    $listbox->bind
      (       '<ButtonRelease-3>' => 
	      sub
	      { 
		$moving_callback = sub {return;};
		return unless(defined($dragging_text));
		$listbox->delete($marker_index);
		$listbox->insert($marker_index, $dragging_text);
		
		$marker_index = undef;
	      }
      );
  }


1;

__END__

=head1 NAME

    ListboxDnD - A Tk::Listbox widget with drag and drop capability.

=head1 DESCRIPTION

   The intent is to add Drag and Drop functionality to the Tk::Listbox
   widget.I would like some beta-testers to see if they can break
   this module or find any bugs with it.

   You can drag items within the listbox to another location 
   within the listbox.

   Issues: I would rather use Button-1, but that seems to conflict
   with the binding that selects items in the listbox.

   Button-3 does not seem to have this issue, although it seems
   a little less intuitive to bind to that button.

   oh well.



=head2 EXPORT


=head1 INSTALLATION

   Just put this file in a directory called "Tk".
   Above that directory, create a test perl script with the following
   code in it: 

        use Tk;
        use Tk::ListboxDnD;
        my $top = MainWindow->new();
        my $listbox = $top->ListboxDnD(-dragFormat=>"<%s>")->pack();
        $listbox->insert('end', qw/alpha bravo charlie delta echo fox/);
        MainLoop();


=head1 AUTHOR


    ListboxDnD - A Tk::Listbox widget with drag and drop capability.
    Copyright (C) 2002  Greg London

    This program is free software; you can redistribute it and/or modify
    it under the same terms as Perl 5 itself.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    Perl 5 License schemes for more details.

    contact the author via http://www.greglondon.com


=head1 SEE ALSO


=cut
