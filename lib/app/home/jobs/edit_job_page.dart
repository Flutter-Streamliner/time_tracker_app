import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker_app/app/home/models/job.dart';
import 'package:time_tracker_app/app/services/database.dart';
import 'package:time_tracker_app/app/widgets/platform_alert_dialog.dart';
import 'package:time_tracker_app/app/widgets/platform_exception_alert_dialog.dart';

class EditJobPage extends StatefulWidget {

  final Database database;
  final Job job;

  const EditJobPage({Key key, @required this.database, this.job}): super(key: key); 

  static Future<void> show(BuildContext context, {Database database, Job job}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(database: database, job: job),
        fullscreenDialog: true
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {

  final _formKey = GlobalKey<FormState>();
  String _name;
  int _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: <Widget>[
          FlatButton(
            child: Text('Save', style: TextStyle(fontSize: 18, color: Colors.white)),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Future<void>  _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) { // allow save to firebase if in edit mode
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, name: _name, ratePerHour: _ratePerHour);
          await widget.database.setJob(job); 
          Navigator.of(context).pop();
        }
      } on PlatformException catch(e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _buildContents() {
    return SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          )
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _name,
        decoration: InputDecoration(labelText: 'Job name'),
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
        decoration: InputDecoration(labelText: 'Rate per hour'),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      ),
    ];
  }

}