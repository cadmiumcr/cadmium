require "./common"

module Cadmium
  class PragmaticTokenizer < Tokenizer
    module Languages
      class Deutsch < Languages::Common
        include Cadmium::I18n::StopWords
        stop_words de
        ABBREVIATIONS = Set.new(%w[a a.d a.k.a a.s.a.p abg alt apr art aug b b.a b.s best bgm bldg btw buchst bzgl bzw c ca co d d.d d.h d.r dergl dez dgl dr dr dt dzt e e.l e.u e.v ehem eig etc etc.p.p eu europ ev ev evtl f f.d feat feb ff fr frz ft g gg ggf ggü griech h h.c h.p hon hosp hr i i.a i.d i.d.r i.f i.p i.z ii iii inkl int iv ix j jan jul jun k k.a k.i.z k.o k.u.k kath l l.a lfd lt ltd m m.e m.w mag max me med mind mio mme mr mrd mrs ms mwst mär n nov nr o o.k o.ä oct okt omg oö p p.a p.m p.s p.t pol pp prof präs q r r.i.p r.r ranz rd rep rt russ s s.g sen sep sog st std str t türk u u.a u.a u.a.m u.a.v u.k u.s u.s.w u.u u.v.a u.v.m u.ä ungar usf usw uvm v v.a v.d v.m vgl vi vii viii vs w wg wr x xi xii xiii xiv xix xv xvi xvii xviii xx y z z.b z.t z.z z.zt zb zt zw zzt ä ö öffentl öst österr ü])
        STOP_WORDS    = stop_words_de
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
