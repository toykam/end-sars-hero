import 'package:flutter/cupertino.dart';
import 'package:sweetalert/sweetalert.dart';

class MessageAlert {


  static LoadingAlert(BuildContext context, {message}) {
    SweetAlert.show(context,
        subtitle: "$message",
        style: SweetAlertStyle.loading
    );
  }


  static confirmAlert(BuildContext context, {message, Function actionAfterConfirm}) {
    SweetAlert.show(context,
      subtitle: "$message",
      style: SweetAlertStyle.confirm,
      showCancelButton: true,
        onPress: (bool isConfirm) {
        if (isConfirm) {
          actionAfterConfirm();
          return false;
        }
        return true;
      }
    );
  }

  static successAlert(BuildContext context, {message, Function action}) {
    SweetAlert.show(context,
      subtitle: "$message",
      style: SweetAlertStyle.success,
      onPress: (bool pressed) {
        if (pressed) {
          return true;
        }
        return false;
      },

    );
  }

  static errorAlert(BuildContext context, {message}) {
    SweetAlert.show(context,
      subtitle: "$message",
      style: SweetAlertStyle.error
    );
  }
  //
  // static infoAlert(BuildContext context, {message}) {
  //   SweetAlert.show(context,
  //       title: "$message",
  //       style: SweetAlertStyle.
  //   );
  // }
}