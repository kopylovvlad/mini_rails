# frozen_string_literal: true

class TestController < ApplicationController
  # before_action :initial_value, only: [:index, :show], unless: -> { @foo.nil? }
  before_action :for_all
  before_action :for_1, only: [:test1]
  before_action :for_2, only: ['test2']
  before_action :except_1, except: [:test1]
  before_action :except_2, except: ['test2']
  before_action :cond_true, only: [:test1, :test2], if: -> { true }
  before_action :cond_true, only: [:test1, :test2], if: :return_true
  before_action :cond_false, if: -> { false }
  before_action :cond_false, if: :return_false

  def test1
    render_json(data: 'test1')
  end

  def test2
    render_json(data: 'test2')
  end

  private

  def for_all
    puts 'CALLBACK: for all'
  end

  def for_1
    puts 'CALLBACK: for test1'
  end

  def for_2
    puts 'CALLBACK: for test2'
  end

  def except_1
    puts 'CALLBACK: except test1'
  end

  def except_2
    puts 'CALLBACK: except test2'
  end

  def cond_true
    puts 'CALLBACK: condition true'
  end

  def return_true
    true
  end

  def cond_false
    puts '!!!!!!'
  end

  def return_false
    false
  end
end
