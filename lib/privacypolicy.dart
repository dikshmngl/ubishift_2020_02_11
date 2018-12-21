import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'home.dart';
void main() => runApp(new MyAppPolicy());

class MyAppPolicy extends StatefulWidget {
  @override
  _MyAppPolicy createState() => _MyAppPolicy();
}

class _MyAppPolicy extends State<MyAppPolicy> {
  String fname="";
  String lname="";
  String desination="";
  String profile="";
  String org_name="";
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      fname = prefs.getString('fname') ?? '';
      lname = prefs.getString('lname') ?? '';
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
      org_name = prefs.getString('org_name') ?? '';
    });
  }
  @override
  Widget build(BuildContext context) {

    String html ='<h2>Privacy Policy</h2><h3>End-User License Agreement ("Agreement")</h3><p>Please read this End-User License Agreement ("Agreement") carefully before  using ubiAttendance App or any Ubitech Solutions’ products or services.</p><p>By downloading or using the Application, you are agreeing to be bound by the terms and conditions of this Agreement.</p><p>If you do not agree to the terms of this Agreement, do not download or use the Application.</p><h4>License</h4><p>Ubitech Inc. grants you a revocable, non-exclusive, non-transferable, limited license to download, install and use the Application solely for your personal, non-commercial purposes strictly in accordance with the terms of this Agreement.</p>';
    html +='<h4>Restrictions</h4><p>You agree not to, and you will not permit others to: license, sell, rent, lease, assign, distribute, transmit, host, outsource, disclose or otherwise commercially exploit the Application or make the Application available to any third party.</p><h4>Modifications to Application</h4><p>Ubitech Solutions reserves the right to modify, suspend or discontinue, temporarily or permanently, the products or any services to which it connects, with or without notice and without liability to you.</p><h4>Term and Termination</h4><p>This Agreement shall remain in effect until terminated by you or Ubitech Solutions.</p><p>Ubitech Solutions may, in its sole discretion, at any time and for any or no reason, suspend or terminate this Agreement with or without prior notice.</p><p>This Agreement will terminate immediately, without prior notice from Ubitech Solutions in the event that you fail to comply with any provision of this Agreement. You may also terminate this Agreement by deleting the Application and all copies thereof from your mobile device or from your desktop.</p><p>Upon termination of this Agreement, you shall cease all use of the Application and delete all copies of the Application from your mobile device or from your desktop.</p><h4>Severability</h4><p>If any provision of this Agreement is held to be unenforceable or invalid, such provision will be changed and interpreted to accomplish the objectives of such provision to the greatest extent possible under applicable law and the remaining provisions will continue in full force and effect.</p><h4>Amendments to this Agreement</h4><p>Ubitech Solutions reserves the right, at its sole discretion, to modify or replace this Agreement at any time</p><h3>Terms of Use ("Terms")</h3><p>Please read these Terms of Use ("Terms", "Terms of Use") carefully before using the www.ubitechsolutions.com, www.ubihrm.com, www.ubiattendance.com  website and the associated products and services operated by Ubitech Solutions ("us", "we", or "our").</p><p>Your access to and use of the Service is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users and others who access or use the Service.</p><p><b>By accessing or using the Service you agree to be bound by these Terms. If you disagree with any part of the terms then you may not access the Service.</b></p><h4>Purchases</h4><p>If you wish to purchase any product or service made available through the Service ("Purchase"), you may be asked to supply certain information relevant to your Purchase.</p><h4>Termination</h4><p>We may terminate or suspend access to our Service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.</p><p>All provisions of the Terms which by their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity and limitations of liability.</p><h4>Content</h4><p>Our Service allows you to post, link, store, share and otherwise make available certain information, text, graphics, videos, or other material ("Content"). You are solely responsible for the activity that occurs on your account, and you must keep your account password secure. We encourage you to use “strong” passwords (passwords that use a combination of upper and lower case letters, numbers and symbols, with a minimum of eight characters) with your account. You must notify Ubitech immediately of any breach of security or unauthorized use of your account. Ubitech will not be liable for any losses caused by any unauthorized use of your account.</p><p>Your account of any Ubitech products gives you access to the Service and any additional functionality that we may develop (and that you may choose to subscribe to, as applicable) from time to time. We may maintain different types of accounts for different types of Users.</p><p>You may never use another User’s account without permission. When creating your account, you must provide accurate and complete information, and you must keep this information up to date. You are solely responsible for the activity that occurs on your account, and you must keep your account password secure. We encourage you to use “strong” passwords (passwords that use a combination of upper and lower case letters, numbers and symbols, with a minimum of eight characters) with your account. You must notify Ubitech immediately of any breach of security or unauthorized use of your account. Ubitech will not be liable for any losses caused by any unauthorized use of your account.</p><p>By providing your email address, you consent to Ubitech using that email address, instead of physical mail, to send you Service-related notices, including any notices required by law. We may also use your email address and any telephone number you provide when setting up your account to send you other messages, such as changes to features of the Service and Service-related offers</p><h4>Links To Other Web Sites</h4><p>Our Service may contain links to third-party web sites or services that are not owned or controlled by Ubitech Solutions.</p>';
    html +='<p>Ubitech Solutions  has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third party web sites or services. You further acknowledge and agree that Ubitech Inc. shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with use of or reliance on any such content, goods or services available on or through any such web sites or services.</p><h4>Changes</h4><p>We reserve the right, at our sole discretion, to modify or replace these Terms at any time.</p><h3>Privacy Policy</h3><p> This privacy notice discloses the privacy practices for www.ubitechsolutions.com. Information Collection, Use, and Sharing<b>Information Collection, Use, and Sharing</b></p><p> We are the sole owners of the information collected on this site. We only have access to/collect information that you voluntarily give us via email or other direct contact from you. We will not sell or rent this information to anyone.</p><p>We will use your information to respond to you, regarding the reason you contacted us. We will not share your information with any third party outside of our organization, other than as necessary to fulfill your request, e.g. to ship an order.</p><p>Unless you ask us not to, we may contact you via email in the future to tell you about specials, new products or services, or changes to this privacy policy.</p><h3>Privacy Policy</h3><h4>Security</h4>';
    html +='<p>We take precautions to protect your information. When you submit sensitive information via the website, mobile app your information is protected both online and offline.</p><p>Wherever we collect sensitive information (such as credit card data), that information is encrypted and transmitted to us in a secure way. You can verify this by looking for a lock icon in the address bar and looking for "https" at the beginning of the address of the Web page.</p>';
    html +='<h3>Cookies Policy</h3><p>Ubitech Solutions ("us", "we", or "our") uses cookies on www.ubitechsolutions.com (the "Service"). By using the Service, you consent to the use of cookies</p><p>We use "cookies" on this site. A cookie is a piece of data stored on a site visitor\'s hard drive to help us improve your access to our site and identify repeat visitors to our site. For instance, when we use a cookie to identify you, you would not have to log in a password more than once, thereby saving time while on our site. Cookies can also enable us to track and target the interests of our users to enhance the experience on our site. Usage of a cookie is in no way linked to any personally identifiable information on our site.</p>';
    html +='<p>Our Cookies Policy explains what cookies are, how we use cookies, how third-parties we may partner with may use cookies on the Service, your choices regarding cookies and further information about cookies.</p><h3>Disclaimer</h3><p>Last updated: November 12, 2018</p><p>The information contained on Ubitech Solutions\' website (the "Service") is for general information purposes only. Ubitech Inc. assumes no responsibility for errors or omissions in the contents on the Service.</p><p>In no event shall Ubitech Solutions be liable for any special, direct, indirect, consequential, or incidental damages or any damages whatsoever, whether in an action of contract, negligence or other tort, arising out of or in connection with the use of the Service or the contents of the Service. Ubitech Inc. reserves the right to make additions, deletions, or modification to the contents on the Service at any time without prior notice Ubitech Inc. does not warrant that the website is free of viruses or other harmful components.</p>';
    html +='<h4>External links disclaimer</h4><p>www.ubitechsolutions.com  and associated websites may contain links to external websites that are not provided or maintained by or in any way affiliated with Ubitech Inc. Please note that the Ubitech Inc. does not guarantee the accuracy, relevance, timeliness, or completeness of any information on these external websites.</p><h4>Fitness disclaimer</h4><p>This content on the websites is designed for educational purposes only. You should not rely on this information as a substitute for, nor does it replace, professional medical advice, diagnosis, or treatment.</p><h4>Contact Us</h4><p>If you have any questions about these Terms, please contact us at support@ubitechsolutions.com</p><p></p>';

    return new Scaffold(
        appBar: new AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(org_name, style: new TextStyle(fontSize: 20.0)),
            ],
          ),
          leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },),
          backgroundColor: Colors.teal,

        ),
        endDrawer: new AppDrawer(),
        body: new SingleChildScrollView(
          child: new Center(
            child: new HtmlView(data: html,),
          ),
        ),
      );

  }
}