import 'package:flutter/material.dart';
import 'package:project_apraxia/widget/form/WaiverForm.dart';

class WaiverPage extends StatefulWidget {
  WaiverPage({Key key}) : super(key: key);

  @override
  _WaiverPageState createState() => _WaiverPageState();
}

class _WaiverPageState extends State<WaiverPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HIPAA Waiver"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("HIPAA Waiver", style: Theme.of(context).textTheme.title,),
          ),

           const Divider(),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
            child: Text("Brigham Young University", style: Theme.of(context).textTheme.body2,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
            child: Text("HIPAA Authorization for Use and Disclosure of Health Information for Research Purposes", style: Theme.of(context).textTheme.body2,),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
            child: Text("IRB Study #", style: Theme.of(context).textTheme.body2,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
            child: Text("Title of Study", style: Theme.of(context).textTheme.body2,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
            child: Text("Principal Investigator: Tyson G. Harmon", style: Theme.of(context).textTheme.body2,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
            child: Text("Mailing Address: 1190 N 900 E, 127 John Taylor Building, Provo, UT 84602", style: Theme.of(context).textTheme.body2,),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
            child: Text("This is a permission called a \"HIPAA authorization.\" It is required by the \"Health Insurance Portability and Accountability Act of 1996\" (known as \"HIPAA\") in order for us to get information related to your health condition to use in this research study.", style: Theme.of(context).textTheme.body2,),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0, top: 4.0),
            child: Text("1. If you sign this HIPAA authorization form, you are giving your permission for the following people or groups to give the researchers certain information about you (described below):"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
            child: Text("Any health care providers or health care professionals or health plans that have provided health services, treatment, or payment for you such as physicians, clinics, hospitals, home health agencies, diagnostics centers, laboratories, treatment or surgical centers."),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0, top: 4.0),
            child: Text("2. If you sign this form, this is the health information about you that the people or groups listed in #1 may give to the researchers to use in this research study: Diagnoses of any communication disorders"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0, top: 4.0),
            child: Text("3. The HIPAA protections that apply to your medical records will not apply to your information when it is in the research study records. Your information in the research study records may also be shared with, used by or seen by collaborating researchers, the sponsor of the research study, the sponsor’s representatives, and certain employees of the university or government agencies (like the FDA) if needed to oversee the research study. HIPAA rules do not usually apply to those people or groups. If any of these people or groups reviews your research record, they may also need to review portions of your original medical record relevant to the situation. The informed consent document describes the procedures in this research study that will be used to protect your personal information. You can also ask the researchers any questions about what they will do with your personal information and how they will protect your personal information in this research study."),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0, top: 4.0),
            child: Text("4. If this research study creates medical information about you that will go into your medical record, you may not be able to see the research study information in your medical record until the entire research study is over."),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0, top: 4.0),
            child: Text("5. If you want to participate in this research study, you must sign this HIPAA authorization form to allow the people or groups listed in #1 on this form to give access to the information about you that is listed in #2. If you do not want to sign this HIPAA authorization form, you cannot participate in this research study. However, not signing the authorization form will not change your right to treatment, payment, enrollment or eligibility for medical services outside of this research study."),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0, top: 4.0),
            child: Text("6. This HIPAA authorization will not stop unless you stop it in writing."),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0, top: 4.0),
            child: Text("7. You have the right to stop this HIPAA authorization at any time. You must do that in writing. You may give your written stop of this HIPAA authorization directly to Principal Investigator or researcher or you may mail it to the department mailing address listed at the top of this form, or you may give it to one of the researchers in this study and tell the researcher to send it to any person or group the researcher has given a copy of this HIPAA authorization. Stopping this HIPAA authorization will not stop information sharing that has already happened."),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0, top: 4.0),
            child: Text("8. You will be emailed a copy of this signed HIPAA authorization."),
          ),

          Divider(thickness: 2.0, color: Colors.black,),

          Container(
            child: WaiverForm(),
          )
        ],
      ),
    );
  }

}
