Rails.application.routes.draw do

  get "/certificate", to: "certificate#generate_certificate"

end
