require "./common"

module Cadmium
  module Tokenizer
    class Pragmatic
      module Languages
        class Deutsch < Languages::Common
          ABBREVIATIONS = Set.new(%w[a a.d a.k.a a.s.a.p abg alt apr art aug b b.a b.s best bgm bldg btw buchst bzgl bzw c ca co d d.d d.h d.r dergl dez dgl dr dr dt dzt e e.l e.u e.v ehem eig etc etc.p.p eu europ ev ev evtl f f.d feat feb ff fr frz ft g gg ggf ggü griech h h.c h.p hon hosp hr i i.a i.d i.d.r i.f i.p i.z ii iii inkl int iv ix j jan jul jun k k.a k.i.z k.o k.u.k kath l l.a lfd lt ltd m m.e m.w mag max me med mind mio mme mr mrd mrs ms mwst mär n nov nr o o.k o.ä oct okt omg oö p p.a p.m p.s p.t pol pp prof präs q r r.i.p r.r ranz rd rep rt russ s s.g sen sep sog st std str t türk u u.a u.a u.a.m u.a.v u.k u.s u.s.w u.u u.v.a u.v.m u.ä ungar usf usw uvm v v.a v.d v.m vgl vi vii viii vs w wg wr x xi xii xiii xiv xix xv xvi xvii xviii xx y z z.b z.t z.z z.zt zb zt zw zzt ä ö öffentl öst österr ü])
          STOP_WORDS    = Set.new(%w[a ab aber ach acht achte achten achter achtes ag alle allein allem allen aller allerdings alles allgemeinen als also am an andere anderen andern anders au auch auf aus ausser ausserdem außer außerdem b bald bei beide beiden beim beispiel bekannt bereits besonders besser besten bin bis bisher bist c d d.h da dabei dadurch dafür dagegen daher dahin dahinter damals damit danach daneben dank dann daran darauf daraus darf darfst darin darum darunter darüber das dasein daselbst dass dasselbe davon davor dazu dazwischen daß dein deine deinem deiner dem dementsprechend demgegenüber demgemäss demgemäß demselben demzufolge den denen denn denselben der deren derjenige derjenigen dermassen dermaßen derselbe derselben des deshalb desselben dessen deswegen dich die diejenige diejenigen dies diese dieselbe dieselben diesem diesen dieser dieses dir doch dort drei drin dritte dritten dritter drittes du durch durchaus durfte durften dürfen dürft e eben ebenso ehrlich ei ei eigen eigene eigenen eigener eigenes ein einander eine einem einen einer eines einige einigen einiger einiges einmal eins elf en ende endlich entweder er erst erste ersten erster erstes es etwa etwas euch euer eure f früher fünf fünfte fünften fünfter fünftes für g gab ganz ganze ganzen ganzer ganzes gar gedurft gegen gegenüber gehabt gehen geht gekannt gekonnt gemacht gemocht gemusst genug gerade gern gesagt geschweige gewesen gewollt geworden gibt ging gleich gott gross grosse grossen grosser grosses groß große großen großer großes gut gute guter gutes h habe haben habt hast hat hatte hatten hattest hattet heisst her heute hier hin hinter hoch hätte hätten i ich ihm ihn ihnen ihr ihre ihrem ihren ihrer ihres im immer in indem infolgedessen ins irgend ist j ja jahr jahre jahren je jede jedem jeden jeder jedermann jedermanns jedes jedoch jemand jemandem jemanden jene jenem jenen jener jenes jetzt k kam kann kannst kaum kein keine keinem keinen keiner kleine kleinen kleiner kleines km kommen kommt konnte konnten kurz können könnt könnte l lang lange leicht leide lieber los m machen macht machte mag magst mahn man manche manchem manchen mancher manches mann mehr mein meine meinem meinen meiner meines mensch menschen mich mir mit mittel mochte mochten morgen muss musst musste mussten muß mußt möchte mögen möglich mögt müssen müsst müßt n na nach nachdem nahm natürlich neben nein neue neuen neun neunte neunten neunter neuntes nicht nichts nie niemand niemandem niemanden noch nun nur o ob oben oder offen oft ohne p q r recht rechte rechten rechter rechtes richtig rund s sa sache sagt sagte sah satt schlecht schon sechs sechste sechsten sechster sechstes sehr sei seid seien sein seine seinem seinen seiner seines seit seitdem selbst sich sie sieben siebente siebenten siebenter siebentes sind so solang solche solchem solchen solcher solches soll sollen sollst sollt sollte sollten sondern sonst soweit sowie später statt t tag tage tagen tat teil tel tritt trotzdem tun u uhr um und und? uns unser unsere unserer unter v vergangenen viel viele vielem vielen vielleicht vier vierte vierten vierter viertes vom von vor w wahr? wann war waren wart warum was wegen weil weit weiter weitere weiteren weiteres welche welchem welchen welcher welches wem wen wenig wenige weniger weniges wenigstens wenn wer werde werden werdet weshalb wessen wie wieder wieso will willst wir wird wirklich wirst wo woher wohin wohl wollen wollt wollte wollten worden wurde wurden während währenddem währenddessen wäre würde würden x y z z.b zehn zehnte zehnten zehnter zehntes zeit zu zuerst zugleich zum zunächst zur zurück zusammen zwanzig zwar zwei zweite zweiten zweiter zweites zwischen zwölf über überhaupt übrigens])
          CONTRACTIONS  = {
            "auf's"             => "auf das",
            "can't"             => "cannot",
            "don't"             => "do not",
            "find's"            => "finde es",
            "für's"             => "für das",
            "g'spür"            => "gespür",
            "gab's"             => "gab es",
            "geht's"            => "geht es",
            "gibt's"            => "gibt es",
            "hab'"              => "habe",
            "hab's"             => "habe es",
            "haben's"           => "haben sie",
            "hat's"             => "hat es",
            "i'm"               => "i am",
            "ich's"             => "ich es",
            "ist's"             => "ist es",
            "it's"              => "it is",
            "kann's"            => "kann es",
            "let's"             => "let us",
            "liebesg'schichten" => "liebesgeschichten",
            "macht's"           => "macht es",
            "ob's"              => "ob es",
            "sag's"             => "sage es",
            "schaut's"          => "schaut es",
            "sich's"            => "sie es",
            "sie's"             => "sie es",
            "sieht's"           => "sieht es",
            "sind's"            => "sind es",
            "spielt's"          => "spielt es",
            "that's"            => "that is",
            "tut's"             => "tut es",
            "war's"             => "war es",
            "weil's"            => "weil es",
            "wenn's"            => "wenn es",
            "wie's"             => "wie es",
            "wir's"             => "wir es",
            "wird's"            => "wird es",
            "wär's"             => "wäre es",
            "ö's"               => "österreichs",
          }

          def self.contractions
            CONTRACTIONS
          end

          def self.abbreviations
            ABBREVIATIONS
          end

          def self.stop_words
            STOP_WORDS
          end
        end
      end
    end
  end
end
