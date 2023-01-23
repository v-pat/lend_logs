

class Person{
  final String name;
  final String finalAmount;
  final String number;

  //if isPaid == true then on display we will show '-'
  final bool isPaid;

  Person(this.name,this.number,this.finalAmount,this.isPaid);

  static Map<String,dynamic> toMap(Person person){
    var map = new Map<String,dynamic>();

    map['name'] = person.name;
    map['final_amount'] = person.finalAmount;
    map['number'] = person.number;
    map['is_paid'] = person.isPaid?1:0;

    return map;
  }

  static Person fromMap(Map<String,dynamic>map){
    var person = new Person(
      map['name'],
        map['number'],
       map['final_amount'],
        map['is_paid']==0?false:true
    );

    return person;
  }

  

}