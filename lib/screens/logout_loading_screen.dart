part of '../main.dart';

class LogoutLoadingScreen extends StatelessWidget {
  const LogoutLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(color: Colors.black),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'KINETIC',
                style: TextStyle(
                  color: Color(0xFFD7FF00),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  height: 1,
                ),
              ),
              Spacer(),
              Center(child: _LogoutPulse()),
              SizedBox(height: 34),
              Text(
                'SIGNING OUT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  height: 0.95,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Closing your session and returning you to the start.',
                style: TextStyle(
                  color: Color(0xFFA4A4A4),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
              Spacer(),
              LinearProgressIndicator(
                minHeight: 5,
                backgroundColor: Color(0xFF1F1F1F),
                color: Color(0xFFD7FF00),
                borderRadius: BorderRadius.all(Radius.circular(999)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutPulse extends StatelessWidget {
  const _LogoutPulse();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      height: 148,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1F1F1F),
        border: Border.all(color: const Color(0xFFD7FF00), width: 4),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color.fromRGBO(215, 255, 0, 0.28),
            blurRadius: 34,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            width: 92,
            height: 92,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              color: Color(0xFFD7FF00),
              backgroundColor: Color(0xFF2A2A2A),
            ),
          ),
          Icon(
            Icons.logout_rounded,
            color: Color(0xFFD7FF00),
            size: 38,
          ),
        ],
      ),
    );
  }
}
