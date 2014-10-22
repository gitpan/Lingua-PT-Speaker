package Lingua::PT::Speaker::Specials;

use strict;

use Text::RewriteRules;

my %sotaques=(
  porto     => {txt => \&porto,
                pho => \&phoporto},
  viseu     => {pho => \&viseu},
  cebolinha => {txt => \&cebolinha},
  spain     => {txt => \&spain,
                pho => \&phospain},
  lamego    => {txt => \&lamego},
);

sub phospecials{  
 my ($sotaq,$t)=@_;
 print "PHO special ($sotaq)\n";
 if(defined($sotaques{$sotaq}{pho})){  &{$sotaques{$sotaq}{pho}}($t)}
 else {$t}; 
}

sub txtspecials{  
 my ($sotaq,$t)=@_;
 if(defined($sotaques{$sotaq}{txt})){&{$sotaques{$sotaq}{txt}}($t)}
 else {$t}; 
}

RULES cebolinha

rr==>r
r==>l

ENDRULES

RULES porto

o�o==>uoum
�o==>oum
am==>om
em\b==>�innhe
v==>b

ENDRULES

RULES phoporto

o:? r==>u 6 r

ENDRULES

RULES lamego

ch([aeiou])==>tx$1
\bx([aeiou])==>tx$1

ENDRULES

RULES viseu

=b=>s/^/_/;
_v==>b_
_s==>S_
_z==>Z_
_S==>Z_
_(.)==>$1_
_$==>

ENDRULES

RULES spain

\bj==>r
��o==>ci�n
��es==>ci�ns
v==>b

ENDRULES

RULES phospain

6==>a
@==>E

ENDRULES

1;
