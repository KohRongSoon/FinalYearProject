import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({ Key? key }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  static const IconData calculate = IconData(0xe121, fontFamily: 'MaterialIcons');
  static const IconData logout_rounded = IconData(0xf88b, fontFamily: 'MaterialIcons');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile')),
      body: Center(
        child:Padding(
          padding:EdgeInsets.only(top: 20.0),
            child:SingleChildScrollView(
               child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 115, 
              width: 115,
              child: Stack(
                fit: StackFit.expand,
                children: const [
                  CircleAvatar(
                    backgroundImage: AssetImage("images/carLogo.jpg"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
             Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.brown[100],
                        fixedSize: const Size.fromHeight(80),
                      ),
                      onPressed: () {}, 
                      child: Row(
                        children: [
                          Icon(Icons.person_outline_sharp),
                          const SizedBox(width: 30 ),                 
                          Expanded(
                            child: 
                              Text("My Account",
                              style: Theme.of(context).textTheme.bodyText1),
                              ),
                          const Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                    ),
                  ),
            const SizedBox(height: 10),
             Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.brown[100],
                        fixedSize: const Size.fromHeight(80),
                      ),
                      onPressed: () {}, 
                      child: Row(
                        children: [
                          const SizedBox(width: 30 ),                 
                          Expanded(
                            child: 
                              Text("Notification",
                              style: Theme.of(context).textTheme.bodyText1),
                              ),
                          const Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                    ),
                  ),
                  const SizedBox(height: 10),
             Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.brown[100],
                        fixedSize: const Size.fromHeight(80),
                      ),
                      onPressed: () {}, 
                      child: Row(
                        children: [
                          Icon(calculate),
                          const SizedBox(width: 30 ),                 
                          Expanded(
                            child: 
                              Text("Calculator",
                              style: Theme.of(context).textTheme.bodyText1),
                              ),
                          const Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                    ),
                  ),
            const SizedBox(height: 10),
             Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.brown[100],
                        fixedSize: const Size.fromHeight(80),
                      ),
                      onPressed: () {}, 
                      child: Row(
                        children: [
                          Icon(logout_rounded),
                          const SizedBox(width: 30 ),                 
                          Expanded(
                            child: 
                              Text("Log Out",
                              style: Theme.of(context).textTheme.bodyText1),
                              ),
                          const Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                    ),
                  ),
          ],
          ),
        ),
            )
       
      ),
    );
  }
}