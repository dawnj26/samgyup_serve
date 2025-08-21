enum InventoryItemOption {
  edit,
  delete;

  String get label {
    switch (this) {
      case InventoryItemOption.edit:
        return 'Edit';
      case InventoryItemOption.delete:
        return 'Delete';
    }
  }
}
