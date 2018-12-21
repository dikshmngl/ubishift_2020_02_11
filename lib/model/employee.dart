class Employee {
  final int response;
  final String fname;
  final String lname;
  final String empid;
  final String email;
  final String status;
  final String orgid;
  final String orgdir;
  final String sstatus;
  final String org_name;
  final String desination;
  final String desinationId;
  final String profile;
  final String org_perm;

  Employee(this.response,this.fname,this.lname,this.empid,this.email,this.status,this.orgid,this.orgdir,this.sstatus,this.org_name,this.desination,this.profile,this.org_perm,this.desinationId);

  Employee.fromJson(Map<String, dynamic> json)
      : response = json['response'],
        fname = json['fname'],
        lname = json['lname'],
        empid = json['empid'],
        email = json['email'],
        status = json['status'],
        orgid = json['orgid'],
        orgdir = json['orgdir'],
        sstatus = json['sstatus'],
        org_name = json['org_name'],
        desination = json['desination'],
        desinationId = json['desinationId'],
        profile = json['profile'],
        org_perm = json['org_perm'];

  Map<String, dynamic> toJson() =>
      {
        'response': response,
        'fname': fname,
        'lname': lname,
        'empid': empid,
        'email': email,
        'status': status,
        'orgid': orgid,
        'orgdir': orgdir,
        'sstatus': sstatus,
        'org_name': org_name,
        'desination': desination,
        'desinationId': desinationId,
        'profile': profile,
        'org_perm': org_perm,
      };

}
