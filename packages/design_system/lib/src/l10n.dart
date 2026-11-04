import 'package:flutter/widgets.dart';

/// Supported languages right from day 1
enum AppLanguage {
  en('EN', 'English'),
  hi('हिं', 'हिंदी');

  final String shortCode;
  final String label;
  const AppLanguage(this.shortCode, this.label);
}

/// Immutable bilingual string holder (English + Hindi)
class Tr {
  final String en;
  final String hi;

  const Tr(this.en, [String? hiText]) : hi = hiText ?? en;

  String of(AppLanguage lang) => lang == AppLanguage.hi ? hi : en;

  @override
  String toString() => en;
}

/// Global/shared language controller with InheritedNotifier so any widget
/// rebuilds immediately when the user toggles EN <-> हिं
class LanguageController extends ChangeNotifier {
  AppLanguage _language;

  LanguageController([this._language = AppLanguage.en]);

  AppLanguage get language => _language;
  bool get isHindi => _language == AppLanguage.hi;

  void toggle() {
    _language =
        _language == AppLanguage.en ? AppLanguage.hi : AppLanguage.en;
    notifyListeners();
  }

  void setLanguage(AppLanguage lang) {
    if (_language != lang) {
      _language = lang;
      notifyListeners();
    }
  }
}

class LanguageScope extends InheritedNotifier<LanguageController> {
  const LanguageScope({
    super.key,
    required LanguageController controller,
    required super.child,
  }) : super(notifier: controller);

  static LanguageController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LanguageScope>();
    assert(scope != null, 'No LanguageScope found in context');
    return scope!.notifier!;
  }

  static AppLanguage langOf(BuildContext context) => of(context).language;
}

extension TrContextExtension on BuildContext {
  AppLanguage get lang => LanguageScope.langOf(this);
  String tr(Tr text) => text.of(lang);
  String trPair(String en, String hi) =>
      lang == AppLanguage.hi ? hi : en;
}

