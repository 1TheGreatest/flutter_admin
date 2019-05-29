import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'HomePage.dart';

class LoginPage extends StatefulWidget {

  static String tag = 'login-page';
  @override
  State<StatefulWidget> createState() => new LoginPageState();
}

enum FormType{
  login,
  register
}

class LoginPageState extends State<LoginPage> with TickerProviderStateMixin {

  final emailController =  TextEditingController();
  final passwordController = TextEditingController();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final formKey = new GlobalKey<FormState>();
  String _email = "admin";
  String _password = "admin";

  FormType _formType = FormType.login;

  @override
  void dispose() {
    super.dispose();

  }


  void  moveToRegister(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }
  void  moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }


  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(

        body: Stack(
          children: <Widget>[

            Container(
                color: Colors.white,
                child: new Form(
                    key: formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(10.0),
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top:50.0),
                                ),
                                Container(
                                    child:SingleChildScrollView(
                                      child: Column(
                                        children: buildInputs() + buildSubmitButtons(),
                                      ),
                                    )
                                )
                              ],
                            ),

                          ],
                        )
                      ],



                    )

                )
            ),


          ],


        )


    );
  }




  List<Widget> buildInputs() {

    if (_formType == FormType.login) {
      return [
        new Hero(
          tag: 'hero',
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 68.0,
              child: Image.asset('assets/loginlogo.jpg'),
            ),
          ),
        ),

        new Container(
          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          child: new TextFormField(
            controller: emailController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Email",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
            ),
          ),
        ),

        new Container(
          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          child:  new TextFormField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Password",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
            ),
          ),
        ),



      ];
    }


  }


  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        new Container(
          padding: const EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                child: new Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Color(0xff01A0C7),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () {
                      if(emailController.text== 'admin' && passwordController.text == 'cinema'){

                        Navigator.pushReplacementNamed(context, '/HomePage');

                      }else if (emailController.text== 'admin' && passwordController.text == 'transport'){
                        Navigator.pushReplacementNamed(context, '/TransportPage');

                      }else if (emailController.text== 'admin' && passwordController.text == 'food'){
                        Navigator.pushReplacementNamed(context, '/FoodPage');

                      }
                      else{
                        Fluttertoast.showToast(
                          msg: "Wrong details",
                          textColor: Colors.white,
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIos: 2,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.indigo.withOpacity(0.5),

                        );

                      }

                    },
                    child: Text("Sign In",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),

            ],
          ),

        ),

      ];
    }

  }

}









