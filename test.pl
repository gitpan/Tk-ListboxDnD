#!/usr/bin/perl
use warnings;
use strict;


        use Tk;
        use Tk::ListboxDnD;
        my $top = MainWindow->new();
#       my $listbox = $top->Scrolled('ListboxDnD', -dragFormat=>"<%s>")->pack();
        my $listbox = $top->ListboxDnD( -dragFormat=>"[[%s]]")->pack();
       $listbox->insert('end', qw/alpha bravo charlie delta echo fox/);
        MainLoop();
