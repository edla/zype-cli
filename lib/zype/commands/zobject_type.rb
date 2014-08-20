require 'thor'

module Zype
  class Commands < Thor

    desc 'zobject-type:list', 'List Zobject types'

    method_option 'query', desc: 'Zobject type search terms',
                  aliases: 'q', type: :string
    method_option 'page', desc: 'The page of Zobject types to return',
                  aliases: 'p', type: :numeric, default: 0
    method_option 'per_page', desc: 'The number of Zobject types to return',
                  aliases: 's', type: :numeric, default: 25

    define_method 'zobject_type:list' do
      init_client

      zobject_types = Zype::Client.new.zobject_types.all(
        :q => options[:query],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_zobject_types(zobject_types)
    end

    desc 'zobject-type:create', 'Create Zobject types'

    method_option 'title', aliases: 't', type: :string, desc: 'Zobject type title'
    method_option 'description', aliases: 'd', type: :string, desc: 'Zobject type description'
    method_option 'videos_enabled', aliases: 'v', type: :string, desc: 'Allow videos to be assigned to this Zobject type'

    define_method 'zobject_type:create' do
      init_client

      zobject_type = Zype::Client.new.zobject_types.create(
        title: options[:title],
        description: options[:description],
        videos_enabled: options[:videos_enabled]
      )

      print_zobject_types([zobject_type])
    end

    no_commands do

      def print_zobject_types(zobject_types)
        puts Hirb::Helpers::Table.render(zobject_types, :fields=>[:_id, :title, :description, :zobject_count, :videos_enabled])
      end
    end

    desc 'zobject-type:update', 'Update a Zobject type'

    method_option 'id', aliases: 'i', type: :string, required: true, desc: 'Zobject type ID'
    method_option 'title', aliases: 't', type: :string, desc: 'Zobject type title'
    method_option 'description', aliases: 'd', type: :string, desc: 'Zobject type description'
    method_option 'videos_enabled', aliases: 'v', type: :string, desc: 'Allow videos to be assigned to this Zobject type'

    define_method 'zobject_type:update' do
      init_client

      if zobject_type = @zype.zobject_types.find(options[:id])
        zobject_type.title = options[:title] unless options[:title].nil?
        zobject_type.description = options[:description] unless options[:description].nil?
        

        zobject_type.save
        print_zobject_types([zobject_type])
      end
      puts ''
    end
  end
end
