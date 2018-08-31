import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/data/models/client_model.dart';
import 'package:invoiceninja_flutter/data/models/invoice_model.dart';
import 'package:invoiceninja_flutter/redux/static/static_state.dart';
import 'package:invoiceninja_flutter/redux/ui/ui_actions.dart';
import 'package:invoiceninja_flutter/ui/payment/payment_screen.dart';
import 'package:invoiceninja_flutter/utils/completers.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja_flutter/redux/payment/payment_actions.dart';
import 'package:invoiceninja_flutter/data/models/payment_model.dart';
import 'package:invoiceninja_flutter/ui/payment/edit/payment_edit.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';

class PaymentEditScreen extends StatelessWidget {
  static const String route = '/payment/edit';

  const PaymentEditScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PaymentEditVM>(
      converter: (Store<AppState> store) {
        return PaymentEditVM.fromStore(store);
      },
      builder: (context, vm) {
        return PaymentEdit(
          viewModel: vm,
        );
      },
    );
  }
}

class PaymentEditVM {
  final PaymentEntity payment;
  final PaymentEntity origPayment;
  final Function(PaymentEntity) onChanged;
  final Function(BuildContext) onSavePressed;
  final BuiltMap<int, InvoiceEntity> invoiceMap;
  final BuiltList<int> invoiceList;
  final BuiltMap<int, ClientEntity> clientMap;
  final BuiltList<int> clientList;
  final Function onBackPressed;
  final StaticState staticState;
  final bool isSaving;
  final bool isDirty;

  PaymentEditVM({
    @required this.payment,
    @required this.origPayment,
    @required this.onChanged,
    @required this.onSavePressed,
    @required this.invoiceMap,
    @required this.invoiceList,
    @required this.clientMap,
    @required this.clientList,
    @required this.staticState,
    @required this.onBackPressed,
    @required this.isSaving,
    @required this.isDirty,
  });

  factory PaymentEditVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final payment = state.paymentUIState.editing;

    return PaymentEditVM(
      isSaving: state.isSaving,
      isDirty: payment.isNew,
      origPayment: state.paymentState.map[payment.id],
      payment: payment,
      staticState: state.staticState,
      invoiceMap: state.invoiceState.map,
      invoiceList: state.invoiceState.list,
      clientMap: state.clientState.map,
      clientList: state.clientState.list,
      onChanged: (PaymentEntity payment) {
        store.dispatch(UpdatePayment(payment));
      },
      onBackPressed: () {
        store.dispatch(UpdateCurrentRoute(PaymentScreen.route));
      },
      onSavePressed: (BuildContext context) {
        store.dispatch(SavePaymentRequest(
            completer: snackBarCompleter(
                context,
                payment.isNew
                    ? AppLocalization.of(context).createdPayment
                    : AppLocalization.of(context).updatedPayment),
            payment: payment));
      },
    );
  }
}