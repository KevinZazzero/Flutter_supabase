import 'package:flutter/material.dart';
import 'package:flutter_supabase/models/book_model.dart';

String _statusLabel(BookStatus status) {
  switch (status) {
    case BookStatus.nonLetto:
      return "Non letto";
    case BookStatus.inLettura:
      return "In lettura";
    case BookStatus.daLeggere:
      return "Da leggere";
    case BookStatus.lasciato:
      return "Lasciato";
    case BookStatus.nonInteressa:
      return "Non interessa";
  }
}

class AddBookView extends StatefulWidget {
  const AddBookView({super.key});

  @override
  State<AddBookView> createState() => _AddBookViewState();
}

class _AddBookViewState extends State<AddBookView> {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController();
    final _authorController = TextEditingController();
    final _genreController = TextEditingController();
    final _pagesController = TextEditingController();
    BookStatus? _selectedStatus;
    double _rating = 3.0;
    final _commentController = TextEditingController();
    

    @override
    void dispose() {
      _titleController.dispose();
      _authorController.dispose();
      _genreController.dispose();
      _pagesController.dispose();
      super.dispose();
  }

    void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dati validi possiamo andare avanti")),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Form ins libro")),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _titleController,
                decoration:  InputDecoration(
                  labelText: 'titolo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                  ? 'campo obbligatorio'
                  : null,
              ),
            ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                  labelText: 'Nome Autore',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                  ? 'campo obbligatorio'
                  : null,
                ),
             ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _genreController,
                  decoration: const InputDecoration(
                    labelText: "Genere",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _pagesController,
                  decoration: const InputDecoration(
                    labelText: 'Numero di pagine',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    final pages = int.tryParse(value);
                    if (pages == null || pages <= 0) {
                      return 'inserisci numero valido';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Stato di lettura',
                  border: OutlineInputBorder(),
                ),
                items: BookStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status, 
                    child: Text(_statusLabel(status)),
                  );
                }).toList(),
                onChanged: (Value) {
                  setState(() {
                    _selectedStatus = Value;
                  });
                },
                validator: (value) => value == null 
                  ? "Seleziona uno stato di lettura" 
                  : null,
                ),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Valutazione', 
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            min: 1,
                            max: 5,
                            divisions: 4,
                            value: _rating,
                            onChanged: (value) {
                              setState(() {
                                _rating = value;
                              });
                            },
                          ),
                        ),
                        Text("${_rating.toStringAsFixed(0)} ⭐")
                      ],
                    ),
                  ],
                ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: 'Inserisci il commento',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true
                  ),
                  maxLines: 4,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Continua"),
              ),
          ],
        ), 
      ),
    ),
  );
}




  
}