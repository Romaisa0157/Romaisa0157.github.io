from flask import Flask, request, jsonify, session, render_template,redirect,flash
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from flask import render_template

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://superuser:superuser@localhost/resolvehub'
app.config['SECRET_KEY']='d5fb8c4fa8bd46638dadc4e751e0d68d'
db = SQLAlchemy(app)

class User(db.Model):
    __tablename__ = 'complaint_users'
    user_id = db.Column(db.Integer, primary_key=True)
    user_email = db.Column(db.String(20), unique=True, nullable=False)
    user_name = db.Column(db.String(20), nullable=False)
    user_password = db.Column(db.Text, nullable=False)
    role = db.Column(db.String(50), nullable=False)

class Student(db.Model):
    __tablename__ = 'student'
    stu_ID = db.Column(db.Integer, primary_key=True)
    batch = db.Column(db.Integer, nullable=False)
    faculty = db.Column(db.String(255), nullable=False)
    deg_program = db.Column(db.String(255), nullable=False)
    hostel = db.Column(db.Integer, nullable=False)
    room_no = db.Column(db.Integer, nullable=False)
    __table_args__ = (
        db.ForeignKeyConstraint([stu_ID],['complaint_users.user_id']),
    )
class FacultyMember(db.Model):
    __tablename__ = 'faculty_member'
    faculty_ID = db.Column(db.Integer, primary_key=True)
    faculty = db.Column(db.String(100), nullable=False)
    occupation = db.Column(db.String(100), nullable=False)
    office_no = db.Column(db.Text)
    __table_args__ = (
        db.ForeignKeyConstraint([faculty_ID],['complaint_users.user_id']),
    )
class Workers(db.Model):
    __tablename__ = 'workers'
    workers_ID = db.Column(db.Integer, primary_key=True)
    hostel_no = db.Column(db.Text)
    service = db.Column(db.String(20), nullable=False)
    faculty = db.Column(db.String(20))
    __table_args__ = (
        db.ForeignKeyConstraint([workers_ID],['complaint_users.user_id']),
    )

class Respondent(db.Model):
    __tablename__ = 'respondent'
    respondent_ID = db.Column(db.Integer, primary_key=True)
    respondent_email = db.Column(db.Text, nullable=False, unique=True)
    respondent_password = db.Column(db.Text, nullable=False)
    respondent_name = db.Column(db.String(20), nullable=False)
    assigned_complaint = db.Column(db.Integer, nullable=False)
    __table_args__ = (
        db.ForeignKeyConstraint([assigned_complaint],['complaint.complaint_ID']),
    )

class Admin(db.Model):
    __tablename__ = 'admin'
    admin_ID = db.Column(db.Integer, primary_key=True)
    admin_email = db.Column(db.Text, nullable=False)
    admin_password = db.Column(db.Text, nullable=False)
    complaint_ID = db.Column(db.Integer, nullable=False)
    respondent_ID = db.Column(db.Integer, db.ForeignKey('respondent.respondent_ID'), nullable=False)
    
    __table_args__ =(
        db.ForeignKeyConstraint([respondent_ID],['respondent.respondent_ID']),
        )
# class Attachments(db.Model):
#     __tablename__ = 'attachments'
#     attachment_ID = db.Column(db.Integer, primary_key=True)
#     complaint_ID = db.Column(db.Integer, db.ForeignKey('complaint.complaint_ID'), nullable=False)
#     file_path = db.Column(db.String(255), nullable=False)

    # ... previous code ...

@app.route("/")
def home():
    return render_template("index.html")
    

@app.route("/complaint")
def complaint():
    return render_template("index.html")
    
@app.route("/display")
def display():
    return render_template("login.html")

#REGISTRATION
@app.route("/registeration")
def user_register():
    return render_template("register.html")

@app.route("/register", methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        confirm_password = request.form.get('confirm_password')
        full_name = request.form.get('name')
        role = request.form.get('role')  # Get the selected role value from the form
        
        # Check if the passwords match
        if password != confirm_password:
            flash('Passwords do not match', 'error')
            return redirect('/register')

        # Check if the email is already registered
        existing_user = User.query.filter_by(user_email=email).first()
        if existing_user:
            flash('Email already registered', 'error')
            return redirect('/register')


        # Create a new user
        new_user = User(user_email=email, user_password=password, user_name=full_name, role=role)
        db.session.add(new_user)
        db.session.commit()

        flash('Registration successful', 'success')
        return redirect('/display')
    return render_template('register.html')


@app.route("/login", methods=['POST'])
def login():
    session['email'] = request.form.get('email')
    session['password'] = request.form.get('password')
    selected_role = request.form.get('role')

    query = text("SELECT * FROM complaint_users WHERE user_email = :param")
    param1 = {"param": session['email']}
    user_login = db.session.execute(query, param1)
    user = user_login.fetchone()

    if user is not None:
        if user['user_email'] == session['email'] and user['user_password'] == session['password']:
            # Check the user's role
            if selected_role == 'Student' and user['role'] == 'student':
                return render_template("complaint.html", email=user['user_email'])
            elif selected_role == 'Faculty Member' and user['role'] == 'faculty member':
                return render_template("complaint.html", email=user['user_email'])
            elif selected_role == 'Worker' and user['role'] == 'worker':
                return render_template("complaint.html", email=user['user_email'])
            else:
                return redirect("/display")
        else:
            return redirect("/display")
    else:
        return redirect("/display")

   

@app.route("/complaint_portal")
def complaint_portal():
    return render_template("complaint.html")
 
@app.route("/complaint_portal",methods = ['POST'])
def submit_complaint():
    issue_date = request.form.get('issue_date')
    complaint_type = request.form.get('complaint_type')
    description = request.form.get('description')
    
    email = request.form.get('email') 
    findid = text("select user_ID from complaint_users where user_email = (:param)" ) 
    param1 = {"param":email}
    
    lodger_id = db.session.execute(findid, param1)
    id = lodger_id.fetchone()[0]
    print('\n\n\n\n\n',id,'\n\n\n\n')
    
     # Insert the complaint data into the complaint table
    query = text("INSERT INTO complaint ( issue_date, complaint_type, description, lodger_ID) "
                 "VALUES (:issue_date, :complaint_type, :description, :lodger_id)")
    params = {
        "issue_date": issue_date,
        "complaint_type": complaint_type,
        "description": description,
        "lodger_id": id
    }
    db.session.execute(query,params)
    db.session.commit()
    query1= text ("Select * from complaint where lodger_ID = (:param)")
    param2 = {"param":id}
    complaints= db.session.execute(query1,param2)
    
    return render_template("complaint.html", email = email, complaints = complaints)

@app.route("/admin_display")
def admin_display():
    return render_template("admin.html")

@app.route("/admin", methods = ['POST'])
def admin():
        session['ad_email'] = request.form.get('ad_email')
        session['ad_password'] = request.form.get('ad_password')

        query = text("SELECT * FROM admin WHERE admin_email = (:param);")
        param1 = {"param": session['ad_email']}
        admin_login = db.session.execute(query, param1)
        user = admin_login.fetchone()

        if user is not None:
            if user['admin_password'] == session['ad_password']:
                query1 = text("select * from complaint");
                complaints = db.session.execute(query1)
                
                query2 = text("select * from respondent");
                respondents = db.session.execute(query2)
                
                return render_template("show_complaint.html",complaints=complaints,respondents=respondents)
            else:
                return redirect("/admin_display")
        else:
            return redirect("/admin_display")
           
@app.route("/about")
def about():
    return render_template("about.html")

@app.route("/respondent_display")
def respondent_display():
    return render_template("respondent.html")


@app.route("/respondent", methods=['POST'])
def respondent():
    session['email'] = request.form.get('r_email')
    session['password'] = request.form.get('r_password')

    query = text("SELECT * FROM respondent WHERE respondent_email = :email;")
    params = {"email": session['email']}
    result = db.session.execute(query, params)
    respondent = result.fetchone()

    if respondent is not None:
        if respondent['respondent_email'] == session['email'] and respondent['respondent_password'] == session['password']:
            query1 = text("SELECT * FROM complaint c INNER JOIN admin_to_respondent r ON c.complaint_ID = r.assigned_complaint_id WHERE r.respondent_id = :respondent_id;")
            params1 = {"respondent_id": respondent['respondent_id']}
            complaints_result = db.session.execute(query1, params1)
            complaints = complaints_result.fetchall()

            return render_template('respondent_portal.html', complaints=complaints, respondent=respondent)
        else:
            return redirect("/respondent_display")
    else:
        return redirect("/respondent_display")



if __name__ == '__main__':
    app.run(debug=True)
