class Word < ActiveRecord::Base

  attr_accessible :definition, :language, :name, :indexed_name

  before_create do |word|
  	word.indexed_name = Parser.indexed_name(word.name)
  end

  def self.query_similar_to lang, word
    if word.nil? || word.empty?
      return []
    end
    Word.order(:indexed_name)
      .where(:language => lang)
      .find(:all, :conditions => ['indexed_name SIMILAR TO ? ', Parser.indexed_name(word) + '_{0,4}'])
      .map{|w| w.name}
  end

  def self.similar lang, word
    cut = word.length; @similar = []
    while(cut > 0 && @similar.count < 3)
      cut -= 2
      @similar = (@similar + Word.query_similar_to(lang, word[0,cut])).uniq
    end
    @similar.sort! do |w1, w2|
      match1 = /(.*).*(\1).*/.match(w1 + word)[1].length
      match2 = /(.*).*(\1).*/.match(w2 + word)[1].length
      if match1 != match2
        match2 <=> match1
      else
        w1.length <=> w2.length
      end
    end
    @similar[0,10]
  end

end
