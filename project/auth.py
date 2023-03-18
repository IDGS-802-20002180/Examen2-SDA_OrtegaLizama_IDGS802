from flask import Blueprint,render_template,redirect,url_for,request,flash
from werkzeug.security import generate_password_hash,check_password_hash
from flask_security import login_required
from flask_security.utils import login_user,logout_user, hash_password, encrypt_password
from .models import User
from . import db,userDataStore

auth = Blueprint('auth',__name__,url_prefix='/security')

@auth.route("/login")
def login():
    return render_template('/security/login.html')

@auth.route("/login",methods=["POST"])
def login_post():
    email=request.form.get('email')
    password=request.form.get('password')
    remember= True if request.form.get('remember') else False
    
    #calculamos si existe un usuario ya registrado con ese email.
    user=User.query.filter_by(email=email).first()
    
    #Verificamos si el usuario existe y comprobamos el password
    if not user or not check_password_hash(user.password,password):
        flash('El usario y/o contraseña son incorrectos')
        return redirect(url_for('auth.login'))
    
    #Si llegamos aqui los datos son correctos y creamos una session para el usuario
    login_user(user,remember=remember)
    return redirect(url_for('main.principalAd'))
    


@auth.route("/register")
def register():
    return render_template('/security/register.html')

@auth.route("/register",methods=["POST"])
def register_post():
    email=request.form.get('email')
    name=request.form.get('name')
    password=request.form.get('password')
    
    #consultamos si existe un usuario ya registrado con ese email.
    user=User.query.filter_by(email=email).first()
    
    if user:
        flash('Ese correo ya esta en uso')
        return redirect(url_for('auth.register'))
    
    #Creamos un nuevo usuario y lo guardamos en la bd.
    #new_user=User(email=email,name=name,password=generate_password_hash(password,method='sha256'))
    
    userDataStore.create_user(name=name,email=email,password=generate_password_hash(password,method='sha256'))
    
    db.session.commit()
    
    return redirect(url_for('auth.login'))

@auth.route("/logout")
@login_required
def logout():
    #Cerramos la sesion
    logout_user()
    return redirect(url_for('main.index'))

@auth.route('/nosotros')
def nosotros():
    
    return render_template('nosotros.html')
