# say to emacs, I want -*- cperl -*- mode
package Lingua::PT::Speaker;
use Lingua::PT::PLN;

use Lingua::PT::Speaker::Numbers;
use Lingua::PT::Speaker::Words2Sampa;
use Lingua::PT::Speaker::Prosody;
use Lingua::PT::Speaker::AdjWords;
use Lingua::PT::Speaker::Specials;

require Exporter;

@ISA = qw(Exporter AutoLoader);
@EXPORT = qw(&speak &toPhon);

$VERSION = "0.05";

use locale;
$ENV{LC_LANG}='PT_pt';

$INC{'Lingua/PT/Speaker.pm'} =~ m!/Speaker\.pm$!;
our $ptpho = "$`/Speaker/ptpho";
our $naoacentuadas = "$`/Speaker/nao_acentuadas";

our $debug;

BEGIN{ $debug = 0;}


$vg = '[6AEIOUaeiouyw@]';
$con = '[BCDFGHJKLMNPQRSTVWXYZÇbcdfghjklmnpqrstvxzç]';


=head1 NAME

Lingua::PT::speaker - perl extension text to speech of Portuguese text

=head1 SYNOPSIS

  use Lingua::PT::speaker;

  $pt1 = '/usr/lib/mbrola/pt1/pt1';

  Lingua::PT::speaker::debug() if $debug;

  my $tmp="/tmp/_$$";

  $/="" if  $l;
  while($line = <>){
     speak({output => "$tmp.pho"}, $line);
     system("mbrola -t $t $pt1 $tmp.pho $tmp.wav; play $tmp.wav"); 
  }

=head1 DESCRIPTION


=head2 EXPORT


=head1 AUTHOR

J.Joao Almeira, jj@di.uminho.pt

Alberto Simões, albie@alfarrabio.di.uminho.pt

=head1 SEE ALSO

Lingua::PT::PLN

mbrola

mbrola/pt1

perl(1).

=cut      

sub debug {
  $debug = ! $debug ; 
}

sub speak {
  my $text = shift;
  my %opt = (output => "_.pho");

  if(ref($text) eq "HASH"){
     %opt= (%opt, %$text);
     $text = shift;
  }

  $text.="." unless $text=~/[!.?]$/;

  $dic = carregaDicionario($ptpho);
  $no_accented = chargeNoAccented($naoacentuadas);

  open PHO, "> $opt{output}";

  while($text =~ s{(\w+\@(\w+\.)+\w+)}{Lingua::PT::Speaker::Numbers::email($1)}ge) {}
  while($text =~ s{(((((ht|f)tp://)|(www\.))(\w+\.)+\w+)(/\w+)*)}{Lingua::PT::Speaker::Numbers::email($1)}ge){}
  while($text =~ s{(\d+[ºª])}{Lingua::PT::Speaker::Numbers::ordinais($1)}ge) {}
  while($text =~ s{(\d+)}{Lingua::PT::Speaker::Numbers::number($1)}ge) {}

  if ($opt{special}) {
    my $special;
    for $special (@{$opt{special}}) {
      $text=Lingua::PT::Speaker::Specials::txtspecials($special,$text)
    }
  }

#  $text=~s{;}{,,}g;

#  print "!$text!\n";
  $text = Lingua::PT::Speaker::Numbers::nontext($text);
  foreach( map{type_sentence($_) } mysentences($text) ) {
    @{$_->{words}} = words($_->{sentence});
    @{$_->{phon}}  = map {toPhon($_,$dic)} @{$_->{words}} ;
    print "\nafter ttf:",join("+",@{$_->{phon}}) if $debug;
    my $t1= Lingua::PT::Speaker::AdjWords::merge(join("/",@{$_->{phon}}));
    if ($opt{special}) {
      my $special;
      for $special (@{$opt{special}}) {
        $t1=Lingua::PT::Speaker::Specials::phospecials($special,$t1)
      }
    }
    @phonemas = (split( /\s+/, $t1), $_->{dot});
    print "\nafter merge:",(join("+",@phonemas)) if $debug;
    print "\nafter prosod:",Lingua::PT::Speaker::Prosody::a( join(" ",@phonemas)) if $debug;
    print PHO Lingua::PT::Speaker::Prosody::a( join(" ",@phonemas)),"\n" ;

  }

  close PHO;

}

sub chargeNoAccented {
  my $file = shift;
  my $dic;
  open F, $file or die ("cannot open dictionary file: $!");
  while(<F>) {
    chomp;
    $dic->{$_}++;
  }
  close F;
  return $dic;
}

sub carregaDicionario {
  my $file = shift;
  my $dic;
  open F, $file or die ("cannot open dicionary file: $!");
  while(<F>) {
    chomp;
    my ($a,$b) = split /=/;
    $dic->{$a}=$b;
  }
  close F;
  return $dic;
}

sub gfdict{ 
  my ($word,$dic) = @_;
  return "" unless ($word =~ /\w/);
  my $res = $dic->{$word};
  unless($res){ $res = $dic->{$1} if( $word =~ /^(.*)s$/ );
                return "" unless ($res);
                if($res =~ /^!/) {$res .= "s"}
                else             {$res .= "S"}
  }
  $res;
}


sub toPhon {
  my ($word,$dic) = @_;
  my $prefix = undef;
  my $res = undef;
  $word = lc($word);

  unless ($word =~ /,/) {
    $res = gfdict($word,$dic); #$dic->{$word};
    #             $res = "$dic->{$1}S" if(!$res &&  $word =~ /(.*)s$/ );
    
    unless ($res || length($word)<3) {

      $prefix = $word;
      do {
	$prefix =~ s{\*$}{}g;
	$prefix =~ s{.$}{*};
	$res = $dic->{$prefix};
      } until ($res || $prefix =~ m!^\w\*! );
    }

    if (defined($prefix)) {
      if ($res) {
	$prefix =~ s{\*$}{}g;
	$res    =~ s{\*$}{}g;
	$word =~ s/^$prefix/$res/;
	undef($res);
      }
    }
  }
  if ($res) {
    if ($res =~ /^!/) {
      $res = toPhon2($');
    }
  } elsif ($no_accented->{$word}) {
    $res = Lingua::PT::Speaker::Words2Sampa::run($word, $debug);
  } else {
    $res = toPhon2($word);
  }
  return $res;
}

sub toPhon2 {
  my $word = shift;
  print "Before silabas: $word\n" if $debug;
  my $t = join "", silabas($word);
  print "After silabas: $t\n" if $debug;
  return Lingua::PT::Speaker::Words2Sampa::run($t, $debug);
}

sub words {
  my $sentence = shift;
  return @words = grep {$_ !~ /^\s*$/} split(/(\s|,|\.|\?)/, $sentence);
}

sub type_sentence {
  my $sentence = shift;
  my $dots = '[.!?:;]+';
  my $dot;
  $sentence =~ /($dots)$/;
  ($sentence,$dot) = ($`,$1);
  return {
	  sentence => $sentence,
	  dot => $dot
	 }
}

sub mysentences {
  my $text = shift;
  my $dots = '[.!?:;]+';
  my @sentences = split(/($dots)/, $text);
  my @retval;

  my $word;
  pop @sentences if (@sentences % 2);

  while($word = shift @sentences) {
    $word.=shift @sentences;
    $word=~s/\n/ /g;
    $word=~s/(^\s+|\s+$)//g;
    $word=~s/\s\s+/ /g;
    push @retval, $word if $word;
  }
  return @retval;
}

sub silabas {
  my $word = shift;
  return split '\|', wordaccent($word);
}

__END__
