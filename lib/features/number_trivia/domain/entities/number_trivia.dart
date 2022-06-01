// ignore: import_of_legacy_library_into_null_safe
import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  final String text;
  final int number;

  NumberTrivia({
   this.number, 
   this.text
  }):super([text,number]);
  
}
