WickedPdf.config = {
    #cross enviroment configs
}

if Rails.env.development?
  WickedPdf.config[:lowquality] = true
end