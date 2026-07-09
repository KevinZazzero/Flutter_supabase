import 'package:flutter/material.dart';
import 'package:flutter_supabase/models/user_profile.dart';
import 'package:flutter_supabase/viewmodel/profile_view_model.dart';
import 'package:flutter_supabase/views/widgets/Bottom_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
    profileVM.loadUserProfile().then((_) {
      final profile = profileVM.profile;
      if (profile != null) {
        _usernameController.text = profile.username;
        _selectedDate = profile.birthdate;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = Provider.of<ProfileViewModel>(context);
    final profile = profileVM.profile;
    return Scaffold(
      appBar: AppBar(title: Text("Profilo utente")),
      body: profileVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: profile?.avatarUrl != null
                              ? NetworkImage(profile!.avatarUrl!)
                              : AssetImage('assets/avatar_placeholder.jpg')
                                    as ImageProvider,
                          child: profile?.avatarUrl == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Inserisci un username';
                        }
                        return null;
                      },
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Data di nascita"),
                      subtitle: Text(
                        _selectedDate != null
                            ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                            : 'Seleziona la tua data di nascita',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final now = DateTime.now();
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(now.year, now.month, now.day),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text("Salva"),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            _selectedDate != null) {
                          final username = _usernameController.text.trim();
                          if (profile == null) {
                            await profileVM.createUserProfile(
                              username,
                              _selectedDate!,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Profilo creato con successo"),
                              ), // SnackBar
                            );
                          } else {
                            final updated = UserProfile(
                              id: profile.id,
                              username: username,
                              birthdate: _selectedDate!,
                              avatarUrl: profile.avatarUrl,
                            );
                            await profileVM.updateUserProfile(updated);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Profilo aggiornato"),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
