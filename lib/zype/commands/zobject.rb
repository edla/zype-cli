require 'thor'
require 'zype/file_reader'

module Zype
  class Commands < Thor
    desc 'zobject:list', 'List Zobjects'

    method_option 'zobject_type', desc: 'Zobject type title',
                  aliases: 's', type: :string,  required: true
    method_option 'query', desc: 'Zobject search terms',
                  aliases: 'q', type: :string
    method_option 'filters', desc: 'Zobject query filters',
                  aliases: 'f', type: :hash, default: {}
    method_option 'active', desc: 'Show active, inactive or all zobjects',
                  aliases: 'a', type: :string, default: 'true', enum: ['true','false','all']
    method_option 'page', desc: 'The page of zobjects to return',
                  aliases: 'p', type: :numeric, default: 0
    method_option 'per_page', desc: 'The number of zobjects to return',
                  aliases: 's', type: :numeric, default: 25

    define_method 'zobject:list' do
      init_client

      params = {
        :q => options[:query],
        :category => options[:category],
        :active => options[:active],
        :page => options[:page],
        :per_page => options[:per_page]
      }

      params.merge!(options[:filters])

      zobjects = @zype.zobjects.all(options[:zobject_type],params)

      print_zobjects(zobjects)
    end

    desc 'zobject:create', 'Create Zobjects'

    method_option 'zobject_type',     aliases: ['s'], type: :string, required: true, desc: 'Specify zobject zobject_type'
    method_option 'attributes', aliases: ['a'], type: :hash, required: false, desc: 'Specify zobject attributes'
    method_option 'pictures', aliases: ['p'], type: :hash, required: false, desc: 'Specify pictures hash'

    define_method 'zobject:create' do
      init_client

      zobject = @zype.zobjects.create(options[:zobject_type],options[:attributes], options[:pictures])

      print_zobjects([zobject])
    end

    no_commands do

      def print_zobjects(zobjects)
        puts Hirb::Helpers::Table.render(zobjects, :fields=>[:_id, :title, :description, :active])
      end
    end
  end
end
