import 'package:flutter/material.dart';
import 'package:ruff_wallet/common/app_localizations.dart';
import 'package:ruff_wallet/common/chain_utils.dart';
import 'package:ruff_wallet/common/wallet_account.dart';
import 'package:ruff_wallet/components/button.dart';
import 'package:ruff_wallet/components/loading.dart';
import 'package:ruff_wallet/pages/app_main_container.dart';

class BackupMnemonicPage extends StatefulWidget {
  static const String routeName = 'BackupMnemonicPage';
  const BackupMnemonicPage({
    Key key,
  }) : super(key: key);

  @override
  _BackupMnemonicPageState createState() => _BackupMnemonicPageState();
}

class _BackupMnemonicPageState extends State<BackupMnemonicPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String mnemonics = generateMnemonic();
  @override
  void initState() {
    super.initState();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  void _saveAccount() async {
    Loading.show(context);
    try {
      String password = ModalRoute.of(context).settings.arguments;
      print("ready fromMnemonic()  password=$password ,mnemonics=$mnemonics");
      var account = await WalletAccount.fromMnemonic(mnemonics, password);
      print("end fromMnemonic() start saveAndActive() account=$account");
      await account.saveAndActive();
      print("end saveAndActive()");
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppMainContainer.routeName, (_) => false);
    } catch (e , s) {
      print("error = $e");
      print(StackTrace.fromString(s.toString()));
      showInSnackBar(AppLocalizations.of(context).backupMnemonicErr + '$e');
      Loading.hide(context);
    }
  }

  Widget infoLine(String text) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5), child: Text(text));
  }

  @override
  Widget build(BuildContext context) {
    Widget mnemonicsSections = Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          width: 1,
          color: Color(0x22000000),
        ),
      ),
      child: Wrap(
        children: mnemonics.split(' ').map(
          (String str) {
            return FractionallySizedBox(
              widthFactor: 1 / 4,
              child: Container(
                alignment: Alignment(0, 0),
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(str),
              ),
            );
          },
        ).toList(),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.layers),
            Container(width: 5),
            Text(AppLocalizations.of(context).backupMnemonicAppBar),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      infoLine(AppLocalizations.of(context)
                          .backupMnemonicSafeAreaInfo1),
                      infoLine(AppLocalizations.of(context)
                          .backupMnemonicSafeAreaInfo2),
                      infoLine(AppLocalizations.of(context)
                          .backupMnemonicSafeAreaInfo3),
                      infoLine(AppLocalizations.of(context)
                          .backupMnemonicSafeAreaInfo4),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment(0, 0),
                        child: Text(
                          AppLocalizations.of(context)
                              .backupMnemonicSafeAreaText1,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      mnemonicsSections,
                      Container(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: mySecondaryButton(
                      AppLocalizations.of(context).backupMnemonicSafeAreaCancel,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    height: 25,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: myPrimaryButton(
                      AppLocalizations.of(context)
                          .backupMnemonicSafeAreaConfirm,
                      onPressed: _saveAccount,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
