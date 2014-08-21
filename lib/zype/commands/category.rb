require 'thor'

module Zype
  class Commands < Thor

    desc 'category:list', 'List Categories'

    method_option 'query', desc: 'Category search terms',
                  aliases: 'q', type: :string
    method_option 'page', desc: 'The page of categories to return',
                  aliases: 'p', type: :numeric, default: 0
    method_option 'per_page', desc: 'The number of categories to return',
                  aliases: 's', type: :numeric, default: 25

    define_method 'category:list' do
      init_client

      categories = Zype::Client.new.categories.all(
        :q => options[:query],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_categories(categories)
    end

    desc 'category:create', 'Create Categories'

    method_option 'title', aliases: 't', type: :string, desc: 'Category title'
    method_option 'values', aliases: 'v', type: :array, desc: 'Category values'
    
    define_method 'category:create' do
      init_client

      category = Zype::Client.new.categories.create(
        title: options[:title],
        description: options[:description],
        videos_enabled: options[:videos_enabled]
      )

      print_categories([category])
    end

    no_commands do

      def print_categories(categories)
        puts Hirb::Helpers::Table.render(categories, :fields=>[:_id, :title, :values])
      end
    end

    desc 'category:update', 'Update a Category'

    method_option 'id', aliases: 'i', type: :string, required: true, desc: 'Category ID'
    method_option 'title', aliases: 't', type: :string, desc: 'Category title'
    method_option 'values', aliases: 'v', type: :array, desc: 'Category values'

    define_method 'category:update' do
      init_client

      puts options.inspect

      if category = @zype.categories.find(options[:id])
        category.title = options[:title] unless options[:title].nil?
        category.values = options[:values] unless options[:values].nil?
      
        category.save
        print_categories([category])
      end
      puts ''
    end
  end
end
