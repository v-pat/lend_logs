import 'package:intl/intl_browser.dart';

class Transactions{
  final String details;
  final String amount;
  final DateTime date;
  final int personId;

  //if isPaid == true then on display we will show '-'
  final int isPaid;

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  Transactions(this.details,this.amount,this.date,this.isPaid,this.personId);

  static Map<String,dynamic> toMap(Transactions transcation){
    var map = new Map<String,dynamic>();

    map['details'] = transcation.details;
    map['amount'] = transcation.amount;
    map['date'] = dateFormat.format(transcation.date);
    map['is_paid'] = transcation.isPaid?1:0;
    map['person_id'] = transcation.personId

    return map;
  }

  static Transactions fromMap(Map<String,dynamic>map){
    var transaction = new Transactions(
      map['details'],
        map['amount'],
       dateFormat.parse(map['date']),
        map['is_paid']==0?false:true,
        map['person_id']
    );

    return transaction;
  }

  

}