class Dog {
  final int? id;
  final String name;
  final int age;

  const Dog({this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'name': name, 'age': age};
    // Only include ID if it's not null (for updates)
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  @override
  String toString() => 'Dog(id: $id, name: $name, age: $age)';
}
