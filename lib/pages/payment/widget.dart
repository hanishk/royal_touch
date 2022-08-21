import 'package:flutter/material.dart';
import 'package:royaltouch/firebase/models.dart';
import 'package:royaltouch/widgets/service_details.dart';

Widget payUsingSavedCard(
  BuildContext context, {
  @required UserDetails userDetails,
  @required Function onPay,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'To remove saved card, go to profile page',
        style: TextStyle(fontSize: 12.0, color: Colors.grey),
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        trailing: FlatButton(
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          child: const Text(
            'Pay using saved card',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Confirm payment using saved card'),
                content: const Text(
                    'Are you sure you want to pay with the saved card ?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('PROCEED'),
                  ),
                ],
              ),
            ).then<void>(
              (value) {
                if (value != null && value) {
                  onPay();
                }
              },
            );
          },
        ),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade600,
                  width: 1.5,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Text(
                userDetails.sqCardOnFile.card.cardBrand,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
        title: Text('Ends in ' + userDetails.sqCardOnFile.card.last4),
        subtitle: Text(userDetails.sqCardOnFile.card.expMonth.toString() +
            '/' +
            userDetails.sqCardOnFile.card.expYear.toString()),
      ),
      const SizedBox(height: 10.0),
    ],
  );
}
