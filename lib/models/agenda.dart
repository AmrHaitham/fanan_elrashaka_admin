class AgendaFields {
  static final List<String> values = [
    id,name, time, amount, mealData, note, type,userEmail,date
  ];

  static final String id = 'id';
  static final String name = 'name';
  static final String time = 'time';
  static final String amount = 'amount';
  static final String mealData = 'mealData';
  static final String note = 'note';
  static final String type = 'type';
  static final String userEmail = 'userEmail';
  static final String date = 'date';

}
class Agenda{
  final int? id;
  final String? name;
  final String? time;
  final num? amount;
  final String? mealData;
  final String? note;
  final int? type;
  final String? userEmail;
  final String? date;

  const Agenda(
      {
        this.id,
        this.name,
        this.time,
        this.amount,
        this.mealData,
        this.note,
        this.type,
        this.userEmail,
        this.date
      });

  static Agenda fromJson(Map<String, Object?> json) => Agenda(
      id: json['id'] as int?,
      name: json['name'] as String?,
      time: json['time'] as String,
      amount: json['amount'] as num?,
      mealData: json['mealData'] as String?,
      note: json['note'] as String?,
      type: json['type'] as int?,
      userEmail:json['userEmail'] as String?,
      date: json['date'] as String?
  );

  Map<String, Object?> toJson() => {
    'id':id,
    'name':name,
    'time':time,
    'amount':amount,
    'mealData':mealData,
    'note':note,
    'type':type,
    'userEmail':userEmail,
    'date':date
  };

  Agenda copy({
    int? id,
    String? name,
    String? time,
    num? amount,
    String? mealData,
    String? note,
    int? type,
    String? userEmail,
    String? date
  }) =>
      Agenda(
          id: id ?? this.id,
          name: name ?? this.name,
          time: time ?? this.time,
          amount: amount ?? this.amount,
          mealData: mealData ?? this.mealData,
          note: note ?? this.note,
          type: type ?? this.type,
          userEmail:userEmail?? this.userEmail,
          date: date??this.date
      );

  @override
  String toString() {
    return 'Agenda{id: $id, name : $name,time: $time, amount: $amount, mealData: $mealData, note: $note, type: $type, userEmail: $userEmail, date: $date}';
  }
}