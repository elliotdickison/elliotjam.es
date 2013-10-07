get '/contact' do
  @page_title = 'Contact'
  @selected_tab = :contact
  erb :contact
end

post '/contact' do
  
  @message = Message.new(params[:message])

  if @message.invalid?
    
    # Throw together a readable error message
    @user_message = build_error_message @message, {name: 'your name', email: 'your email address', body: 'the message body'}

  elsif @message.save
    if settings.send_mail
	  begin
	    Pony.mail({
	  	  from: "#{params[:name]} <#{params[:email]}>",
	  	  to: settings.contact_email,
	  	  subject: "Contact Form at elliotjam.es",
	      body: params[:body]
	    })
	    @user_message = "Thanks, I'll get back to you as soon as I can.";
	    @message = nil
	  rescue
		# Error message below
	  end
	end
  end

  @page_title = 'Contact'
  @selected_tab = :contact
  @user_message ||= 'Sorry, seems a mouse has chewed through the wires someplace. Please try again later.'
  @user_message_target = 'contact_form'

  erb :contact
end