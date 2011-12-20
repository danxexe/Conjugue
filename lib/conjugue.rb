require 'conjugue/verb_database'

module Conjugue

  def self.verbo(name, time, person, plural = false)
    unless name =~ /r$/
      unless name =~ /[aeiou]$/
        name += 'a'
      end
      name += 'r'
    end

    time = VerbDatabase::TIMES[time]
    plural = false if plural == :s

    person -= 1
    person += 3 if plural

    paradigm = (VerbDatabase.find_by_verb(name) or VerbDatabase.find_by_paradigm(name) or VerbDatabase.find_by_sufix(name))
    
    unless paradigm[:conjugations][time]
      puts 'time not found'
      paradigm = VerbDatabase.find_by_sufix(name)
    end

    if paradigm
      sufix = (paradigm[:sufix].to_s.empty? ? paradigm[:name] : paradigm[:sufix])
      conjugate = paradigm[:conjugations][time][person]
      radical_paradigm = paradigm[:name].gsub(Regexp.new(sufix+'$'), '')
      sufix_conjugate = conjugate.gsub(Regexp.new('^'+radical_paradigm), '')
      radical_verb = name.gsub(Regexp.new(sufix+'$'), '')

      conjugate = radical_verb + sufix_conjugate
    end

    ret = "#{VerbDatabase::PRONOUNS[person]} #{conjugate}"
    ret.encode('UTF-8')
  end

end