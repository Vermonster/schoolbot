class ClientController < ApplicationController
  def show
    render file: Rails.root.join('client', 'dist', 'index.html')
  end
end
