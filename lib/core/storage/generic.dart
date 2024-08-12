import 'package:rxdart/rxdart.dart';

class GenericStore<T> {
  late final BehaviorSubject<T> _subject;

  GenericStore(T initialValue) {
    _subject = BehaviorSubject<T>.seeded(initialValue);
  }

  // Stream to access the current value
  Stream<T> get stream => _subject.stream;

  // Get the current value synchronously (potentially throws if no value emitted yet)
  T get value => _subject.value;

  // Emit a new value to the stream
  void emit(T newValue) => _subject.add(newValue);

    void refresh() => _subject.add(_subject.value);


  // Close the subject and release resources
  void close() {
    _subject.close();
  }
}