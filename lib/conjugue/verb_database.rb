module Conjugue
  module VerbDatabase
    class << self
      def init
        puts "Verb database initialized."
        
        @paradigms = {}
        @verbs = {}
        @sufixes = {}
        
        parse
      end
      
      COMMENT_RX = /^#/
      PARADIGM_RX = /paradigma:([^:]*):?([^:]*)?/
      PARADIGM_END_RX = /^$/
      
      CONJUGATIONS = %w(FN IP PI II EI MI TI FI PS IS FS IA IN)
      CONJUGATION_RX = /^(#{CONJUGATIONS.join('|')}):(.*)/
      
      def parse
        state = nil
        paradigm = nil

        database_file = File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'data', 'verbos')
        
        File.open(database_file, 'r:ISO-8859-1') do |file|
          file.each_line do |line|
            next if line =~ COMMENT_RX # comments
            
            ########################################
            # nil state
            ########################################
            if state == nil
              
              # enter paradigm state
              ########################################
              if line_match = line.match(PARADIGM_RX)
                state = :paradigm
                paradigm = {}
                paradigm[:name] = line_match[1].strip
                paradigm[:sufix] = line_match[2].strip
                paradigm[:verbs] = []
                paradigm[:conjugations] = {}
                
                @paradigms[paradigm[:name]] = paradigm

                @sufixes[paradigm[:sufix]] = paradigm unless paradigm[:sufix].to_s.empty?
              end # line.match(PARADIGM_RX)
              
            ########################################
            # paradigm state
            ########################################
            elsif state == :paradigm
              
              # exit paradigm state
              ########################################
              if line =~ PARADIGM_END_RX
                state = nil
                next
              end
              
              # conjugation
              ########################################
              if line_match = line.match(CONJUGATION_RX)
                paradigm[:conjugations][line_match[1].strip] = line_match[2].strip.split(':')
                
              # verb
              ########################################
              else
                verb = line.strip
                paradigm[:verbs] << verb
                @verbs[verb] = paradigm
              end
            end
          end # file.each_line
        end # File.open
      end # def parse

      def find_by_verb(verb)
        puts "found verb: #{verb}" if paradigm = VerbDatabase.verbs[verb]
        return paradigm
      end

      def find_by_paradigm(verb)
        paradigm = nil
        puts "found paradigm: #{paradigm[:name]}" if paradigm = VerbDatabase.paradigms[verb]
        return paradigm
      end

      def find_by_sufix(verb)
        sufix = VerbDatabase.sufixes.keys.find_all{ |s| verb =~ Regexp.new(s+'$') }.max_by{|s| s.size }
        puts "found sufix: #{sufix}" if sufix
        VerbDatabase.sufixes[sufix]
      end
      
      def paradigms
        @paradigms
      end
      
      def verbs
        @verbs
      end

      def sufixes
        @sufixes
      end

    end # class << self

    TIMES = {
      :p => 'PI',
      :pi => 'II',
      :pp => 'EI',
      :pm => 'MI',
      :f => 'TI',
      :fp => 'FI',
      :ps => 'PS',
      :pis => 'IS',
      :i => 'IA',
      :in => 'IN'
    }

    PRONOUNS = [
      'Eu',
      'Tu',
      'Ele',
      'Nos',
      'Vos',
      'Eles'
    ]
    
    self.init
  end # module VerbDatabase
end