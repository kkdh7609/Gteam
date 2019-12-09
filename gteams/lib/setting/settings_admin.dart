import 'package:flutter/material.dart';
import 'package:gteams/root_page.dart';
import 'package:gteams/manager/AdminData.dart';
import 'package:gteams/services/crud.dart';
import 'package:gteams/manager_main/ManagerMainMenu.dart';

class SettingAdminPage extends StatefulWidget {
  SettingAdminPage({Key key, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => new _SettingAdminPageState();
}

class _SettingAdminPageState extends State<SettingAdminPage> {
  AdminData _adminData = AdminData();
  crudMedthods crudObj = new crudMedthods();

  @override
  void initState() {
    super.initState();
    var userQuery = crudObj.getDocumentByWhere('user', 'email', RootPage.user_email);

    userQuery.then((data){
      if(data.documents.length >= 1) {
        _adminData.name = data.documents[0].data['name'];
        _adminData.email = data.documents[0].data['email'];
        _adminData.myStadium = data.documents[0].data['myStadium'];

        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) =>
                ManagerMainMenuPage(onSignedOut: widget.onSignedOut)));
      }
    });

  }

/*  Widget userInfo(){
    return StreamBuilder<QuerySnapshot>(
        stream : Firestore.instance.collection("user").where('email',isEqualTo: RootPage.user_email).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return LinearProgressIndicator();
          this._adminData = snapshot.data.documents.map((data) => AdminData.fromJson(data.data)).elementAt(0);
          return  Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 40.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Row(
                      children: <Widget>[
                        Text(
                          _adminData.name,
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        /*appBar: AppBar(
          title: Text("Setting Admin"),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                widget.onSignedOut();
                new RootPage(auth: new Auth());
              },
            )
          ],
        ),
        body: Container(
            child: Center(
                child: Column(
          children: <Widget>[
            userInfo(),
          ],
        )
            )
        )*/
        body: Text("loading")
    );
  }
}
