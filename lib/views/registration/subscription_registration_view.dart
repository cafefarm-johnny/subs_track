import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subs_track/models/subscription/subscription_model.dart';
import 'package:subs_track/viewmodels/subscription/subscription_notifier.dart';
import 'package:intl/intl.dart';

class SubscriptionRegistrationView extends ConsumerStatefulWidget {
  const SubscriptionRegistrationView({super.key});

  @override
  ConsumerState<SubscriptionRegistrationView> createState() =>
      _SubscriptionRegistrationViewState();
}

class _SubscriptionRegistrationViewState
    extends ConsumerState<SubscriptionRegistrationView> {
  final _formKey = GlobalKey<FormState>();

  final _serviceNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _paymentDayController = TextEditingController();

  PaymentFrequency _selectedFrequency = PaymentFrequency.monthly;
  Currency _selectedCurrency = Currency.krw;
  DateTime? _selectedDate;

  String? _handleServiceNameValidate(String? value) {
    if (value == null || value.isEmpty) {
      return '서비스 이름을 입력해주세요.';
    }

    return null;
  }

  String? _handleAmountValidate(String? value) {
    if (value == null || value.isEmpty) {
      return '구독료를 입력해주세요.';
    }

    if (int.tryParse(value) == null) {
      return '유효한 숫자를 입력해주세요.';
    }

    return null;
  }

  Future<void> _selectDate(FormFieldState<String> selectedField) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2_000),
      lastDate: DateTime(2_100),
      barrierDismissible: false,
      locale: const Locale('ko', 'KR'),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.day,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            // InkWell 효과 제거
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                // 텍스트 버튼 폰트 컬러
                foregroundColor: Theme.of(context).colorScheme.primary,
                // 텍스트 버튼 스타일
                textStyle: Theme.of(context).textTheme.bodyLarge,
                splashFactory: NoSplash.splashFactory,
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              // 날짜 텍스트 색상
              dayStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              // 오늘 날짜 테두리 색상
              todayBorder: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              ),
              dayOverlayColor: WidgetStateProperty.all(
                // 날짜 선택 시 오버레이 색상
                Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.1),
              ),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                // 선택된 날짜 색상
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Theme.of(context).textTheme.bodyLarge?.color;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                // 선택된 날짜 배경색상
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).colorScheme.primary;
                }
                return Colors.transparent;
              }),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _paymentDayController.text = picked.day.toString();
        selectedField.didChange(picked.day.toString());
      });
    }
  }

  String? _handlePaymentDayValidate(String? value) {
    if (value == null) {
      return '결제일을 선택해주세요.';
    }

    return null;
  }

  void _handleFrequencyChange(PaymentFrequency? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _selectedFrequency = value;
    });
  }

  void _handleCurrencyChange(Currency? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _selectedCurrency = value;
    });
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      return;
    }

    final newSubscription = SubscriptionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      serviceName: _serviceNameController.text.trim(),
      amount: int.parse(_amountController.text),
      frequency: _selectedFrequency,
      paymentDay: int.parse(_paymentDayController.text),
      currency: _selectedCurrency,
    );

    ref.read(subscriptionProvider.notifier).addSubscription(newSubscription);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('구독 정보 등록 완료: ${newSubscription.serviceName}'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('구독 정보 등록')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _createServiceNameTextField(),
              const SizedBox(height: 16),
              _createAmountTextField(),
              const SizedBox(height: 16),
              _createPaymentDayTextField(),
              const SizedBox(height: 16),
              _createFrequencyDropdown(),
              const SizedBox(height: 16),
              _createCurrencyDropdown(),
              const SizedBox(height: 32),
              _createSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _amountController.dispose();
    _paymentDayController.dispose();

    super.dispose();
  }

  Widget _createServiceNameTextField() {
    return TextFormField(
      controller: _serviceNameController,
      decoration: const InputDecoration(labelText: '서비스 이름'),
      validator: _handleServiceNameValidate,
    );
  }

  Widget _createAmountTextField() {
    return TextFormField(
      controller: _amountController,
      decoration: const InputDecoration(
        labelText: '구독료',
        hintText: '숫자만 입력 (예: 4900)',
      ),
      keyboardType: TextInputType.number,
      validator: _handleAmountValidate,
    );
  }

  Widget _createPaymentDayTextField() {
    return FormField(
      initialValue: _selectedDate?.day.toString(),
      validator: _handlePaymentDayValidate,
      builder: (FormFieldState<String> field) {
        return GestureDetector(
          onTap: () => _selectDate(field),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: '결제일',
              hintText: '날짜를 선택하세요',
              suffixIcon: Icon(Icons.edit_calendar),
              errorText: field.errorText,
            ),
            child: Text(
              _selectedDate != null
                  ? DateFormat('yyyy년 M월 d일').format(_selectedDate!)
                  : '날짜를 선택하세요',
            ),
          ),
        );
      },
    );
  }

  Widget _createFrequencyDropdown() {
    return DropdownButtonFormField<PaymentFrequency>(
      value: _selectedFrequency,
      decoration: const InputDecoration(labelText: '결제 주기'),
      items:
          PaymentFrequency.values.map((frequency) {
            return DropdownMenuItem(
              value: frequency,
              child: Text(frequency.isMonthly ? '매월' : '매년'),
            );
          }).toList(),
      onChanged: _handleFrequencyChange,
    );
  }

  Widget _createCurrencyDropdown() {
    return DropdownButtonFormField<Currency>(
      value: _selectedCurrency,
      decoration: const InputDecoration(labelText: '통화'),
      items:
          Currency.values
              .map(
                (currency) => DropdownMenuItem(
                  value: currency,
                  child: Text(currency.name.toUpperCase()),
                ),
              )
              .toList(),
      onChanged: _handleCurrencyChange,
    );
  }

  Widget _createSubmitButton() {
    return ElevatedButton(onPressed: _handleSubmit, child: const Text('등록'));
  }
}
