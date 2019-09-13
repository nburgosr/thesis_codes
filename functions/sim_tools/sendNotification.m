function sendNotification(tittle,message,destiny)
%Función para dar aviso del estado de simulaciones por medio de un correo.

mail = 'remitente@gmail.com'; %Ingresar dirección de correo de remitente
password = 'clave'; %Ingresar clave de correo de remitente
setpref('Internet','SMTP_Server','smtp.gmail.com');

setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

sendmail(destiny,tittle,message)

end