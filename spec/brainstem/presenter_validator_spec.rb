require 'spec_helper'
require 'spec_helpers/presenters'
require 'brainstem/presenter_validator'

describe Brainstem::PresenterValidator do
  let(:presenter_class) do
    Class.new(WorkspacePresenter) do
      presents Workspace
    end
  end

  let(:validator) { Brainstem::PresenterValidator.new(presenter_class) }

  it 'should be valid' do
    expect(presenter_class.configuration[:preloads]).not_to be_empty
    expect(presenter_class.configuration[:fields]).not_to be_empty
    expect(presenter_class.configuration[:associations]).not_to be_empty
    expect(validator).to be_valid
  end

  describe 'validating preload' do
    it 'adds an error if the requested preload does not exist on the presented class' do
      presenter_class.presenter do
        preload :foo
      end

      expect(validator).not_to be_valid
      expect(validator.errors[:preload]).to eq ["not all presented classes respond to 'foo'"]
    end

    it 'adds an error if the requested preload does not exist on only one of the presented classes' do
      presenter_class.presents User
      expect(validator).not_to be_valid
      expect(validator.errors[:preload]).to eq ["not all presented classes respond to 'lead_user'"]
    end
  end

  describe 'validating fields' do
    it 'adds an error for any field that is not on all presented classes' do
      presenter_class.presenter do
        fields do
          field :foo, :string
          field :bar, :integer
        end
      end

      expect(validator).not_to be_valid
      expect(validator.errors[:fields]).to eq ["'foo' is not valid because not all presented classes respond to 'foo'",
                                               "'bar' is not valid because not all presented classes respond to 'bar'"]
    end

    it 'errors when one of the presented classes is missing a field' do
      presenter_class.presents User
      expect(validator).not_to be_valid
      expect(validator.errors[:fields]).to be_present
    end

    it 'supports :via' do
      presenter_class.presenter do
        fields do
          field :foo, :string, via: :title
        end
      end

      expect(validator).to be_valid
    end

    it "checks that any 'if' option has a matching conditional(s)" do
      expect(presenter_class.configuration[:conditionals][:title_is_hello]).to be_present

      presenter_class.presenter do
        fields do
          field :title, :string, if: :title_is_hello
        end
      end

      expect(validator).to be_valid

      presenter_class.presenter do
        fields do
          field :title, :string, if: [:title_is_hello, :wat]
        end
      end

      expect(validator).not_to be_valid
      expect(validator.errors[:fields]).to eq ["'title' is not valid because one or more of the specified conditions does not exist"]
    end
  end

  specify 'all spec presenters should be valid' do
    UserPresenter.presents User
    TaskPresenter.presents Task
    WorkspacePresenter.presents Workspace
    PostPresenter.presents Post

    Brainstem.presenter_collection.presenters.each do |klass, instance|
      expect(Brainstem::PresenterValidator.new(instance.class)).to be_valid
    end
  end
end
