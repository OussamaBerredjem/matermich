
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/messaging.dart';
import 'package:get/get.dart';
import 'package:matermich/services/account_controller.dart';

class SendNotification{

  late FirebaseAdminApp  admin;
  SendNotification();
  final AccountController _accountController = Get.find(tag: "account");

 

  Future<void> sendNotification({required String uid,required String title ,required String body,bool isMessage = false,String imageUrl = ""}) async{
    
    try {

    var doc =  await FirebaseFirestore.instance.collection("users").doc(uid).get();

    String token = doc.get("notificationID");

    admin = FirebaseAdminApp.initializeApp(
    'matermich-7828c',
    Credential.fromServiceAccountParams(clientId: "106780737409898110000", privateKey: "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCFNqYPzGts54QP\nM4c3cqJgobTUpQ1CnUE38l+7etPOMoSCVbBi5Pb2M9o1kG8SlhJvr2LT2LGWnLeh\nRPCP8EVZ/k6kV+bGaTSHSja6LEO2ejmoX1gTeCebdMMxwRILgre6RLAyk541/xXr\nIvPdUn7T+bA4hJ5icbDNm6ANJrw1KjGC2xPhebgCMf+NYySIo9gNNIhbJwZ89z2b\nHlXtf+0gOXPbvclABcAzKQ1xlJSjmqjOIelDClx/L0GVAI1SQm9yiUG3BER4f1aC\n/Ym49/c8vos/sD8/Vya+q3mxfq6nVgWoxjbahVIltSTyH8wIBO0iaRIIi6GRZm8E\nFDJacPYnAgMBAAECggEADWFAS6zuC0mzp203Axg1+/ux9HvBebPexZZIDEYZeQf0\n7DxcE4rIzVDG9YNUzKqbHnGgvQNyTtzdyspoWSS6aoAS+QnFKZ+OgZowJgHlKTJc\nkS9GYuo6HDCdnGU2gUZ3WrOkeOf/x4+f7XacxNmQ2IynKP4VBHFD31rmt/twguxd\nZOd1a3NhlU+9sotOEuS8cA/3UHoj2bz5zgpHMS2qnuZUgSpJO4thsKD20LQUeB64\nDfK+tdEJYM1wnZFAdILMcl2bLHD3yoHJLY+5s88ulhe8wdVHeGKBcVlaQHzSIq0d\npnVtA+9APviN3ZO9vZpcSMnyZq90YwcgxrfiQnLWyQKBgQC5T33F77gtUN5YHWQ7\nh0GFYZrEtuXinpyvKZ/j99IIOGcnxEBjRgFdLANF6OqpjUk4Cq94RsWlhSZPD9Tq\nP48pGC+lAvQIwlk+fceY5Bq3W0nCN50i66idHfByAjBtYKHgUbDLEGIXoVPlA0Lx\n14LZtP2OMYATgxYUPwDKrHEePwKBgQC4B54pfNGLSbpdZbp6FJ+BSfzr71XWOjiV\nXYUqDUqm8xoOCpYPKLiFVFIeClSVsbggGNcL09nfpLwQIqorAZ4FxJ4d+adB5Wr2\nbKoeCnrg+dkDYn6r3f+hzeQYUSDYTzsB1G0o/+7V28uQjIrHqfrvHer0EwVKZ9wd\n80WnLP5+GQKBgGC3kWBmjkzwgSuiI3dCT7sqxxlWkEMoH4T4h5/27yMlNQm3TxfB\nKOMVHpw1RYy61fUu9ogi//M0vFrVW33rMG/1VKCeGvobXXLVOQCeRSdfuO5qElRw\nhK+EOcN3Swk7PyGR4WEKqvfEVsIXYrBQl9XCtfep9Du61iI5A9PEDsIHAoGAVbFO\nZ7k0heyV+GmnVLOHtpdyS5bN3IyNzpeWq4c27NikmEc7quFmUsd52X0r9+yidWe7\ns0k52dcGr2jE3nPJVpxAmGqpBJlEnmzpJkXxBBOzhsz1eShNodWS0fPtHGyAaJC3\nJ/FNEI5hkvSuptyy+WdwAaldvFDygYvHMlpUQvkCgYBF+SW1vSuX17oaM6JYnWZg\nk1W44GiAbhQYTjVtLCWFyD47qODmaOW1BjZxX3ec1X0myjvHWvfrUn3ifS4eA1w9\nOCLqWtITJWoobB5cPrCul1iIuKw7iVuzferLr9vLh7L+LQt4nQqt4pIwzl27lViV\n9NIvuFN1nSXB4Mvb46D33w==\n-----END PRIVATE KEY-----\n", email: "firebase-adminsdk-5xssv@matermich-7828c.iam.gserviceaccount.com"),
  );

    final messaging = Messaging(admin);


  final result = isMessage? await messaging.send(
    TokenMessage(
      token:token,
      android: AndroidConfig(
        notification: AndroidNotification(
          title: title,
          body: body,
          imageUrl:isMessage?_accountController.information.value.image:(imageUrl.isEmpty?null:imageUrl)
        )
      ),
      notification: Notification(
        title: title,
        imageUrl: imageUrl.isEmpty?null:imageUrl,
        body: body),
    ),
  ) :await messaging.send(
    TokenMessage(
     android: AndroidConfig(
        notification: AndroidNotification(
          title: title,
          body: body,
          imageUrl:isMessage?_accountController.information.value.image:(imageUrl.isEmpty?null:imageUrl)
        )
      ),
      token:token,
      notification: Notification(
        title: title,
        imageUrl: _accountController.information.value.image,
        body: body),
    ),
  )  ;

    } catch (e) {
    }

     
  }
}