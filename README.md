
ТЗ на разработку мобильного приложения
ВНИМАНИЕ!!!
ПРИ СОЗДАНИИ ПРОЕКТА НЕ НУЖНО УКАЗЫВАТЬ НАЗВАНИЕ
КОМПАНИИ!!! (delta_project или delta_test) - не нужно так называть
свои проекты или где-то в коде указывать название компании.
Делается это для того чтобы другие кандидаты не смогли найти ваш
проект на гит и использовать ваш код для своего приложения.
Спасибо за понимание :)
Для тестового необходимо использовать свой google-services.json,
после завершения заглушки и логики, скинем данные для прилы:
google-services.json , package name, иконка - добавляем иконку
приложения и делаем с этой иконки экран загрузки
1. Каждый раз для нового приложения будут скидывать json, вот
его добавляем в наш проект и через remote config обращаемся к
переменной url, там будет ссылка.
2. После получения ссылки, создаем условие для проверки, если
ссылка пустая, бренд смартфона гугл, нет сим карты или
эмулятор, тогда открывается заглушка.
3. Если условие не проходит, открываем ссылку через Webview,
при этом блокируем в браузере системную кнопку назад на
стартовой странице, но даем возможность перехода назад
между страницами в вебвью, ссылку необходимо сохранить
локально.
4. При повторном запуске проверяем есть ли сохраненная
ссылка- да, открываем сразу её, нет- обращаемся к firebase,
проходим через 2 условие

Сроки: можно несколько дней,но чем быстрее,тем лучше) Мы ценим
обратную связь, поэтому будем рады ссылке github на тестовый
проект, чтобы мы могли проверять и направлять:)

Заглушка: В зависимости от заглушки оценивается ТЗ.
Заглушку выбрать из этого списка:
- План здорового / спортивного питания (2к Руб)
- Упражнения на разные группы мышц (2к Руб)
- Квиз Игры и Викторины по разным видам спорта (2к Руб)
- Факты и Достижения в спорте или про определенный вид
спорта (2к Руб)
- Игра типа - пробей пенальти,игры в стаканы,симуляторы
ставок на очки,тетрис на очки , прыгающий мяч и тд (3к Руб)
- Личный фитнес инструктор (2к Руб)
- План похудения на 30 дней (2.5к Руб)
- Секундомер + дневник тренировок (2.5к Руб)
- Расписание спортивных событий (1к Руб)
- Новости о спорте (1к Руб)

1. Описание работы приложения
1.1. Схема работы приложения

![alt text](https://iili.io/Hnm85Ss.md.png)
<a href="https://freeimage.host/i/Hnm85Ss"><img src="" alt="Hnm85Ss.md.png" border="0"></a>

1.2. Получаем конфигурацию от Firebase Config.
■ Если Firebase возвращает ссылку - открываем ее в вебвью,
но перед этим необходимо ее сохранить локально.
■ Если Firebase возвращает пустую строку - открываем
заглушку.
■ Блок функции Firebase Remote Config в try - catch, если
firebase rem con получает ошибку при обработке - в catch
отлавливаем этот момент и отображаем экран с выводом
ошибки .
■ Если при запуске с локальной ссылкой нет интернета,
отображаем экран - для продолжения необходимо
подключение к сети
Важно!!! Для корректной работы вебвью добавим зависимости в
AndroidManifest:
<uses-permission android:name="android.permission.INTERNET"/>
android:usesCleartextTraffic="true"
android:exported="true"
Что должно получится :

![alt text](https://i.ibb.co/b3k2CVD/manifest.png)

1.3. Условие для проверки эмулятора
Пример проверки на Java:
private fun checkIsEmu(): Boolean {
if (BuildConfig.DEBUG) return false // when developer use this build on
emulator
val phoneModel = Build.MODEL val buildProduct = Build.PRODUCT
val buildHardware = Build.HARDWARE
var result = (Build.FINGERPRINT.startsWith("generic")
|| phoneModel.contains("google_sdk")
|| phoneModel.lowercase(Locale.getDefault()).contains("droid4x")
|| phoneModel.contains("Emulator")
|| phoneModel.contains("Android SDK built for x86")
|| Build.MANUFACTURER.contains("Genymotion")
|| buildHardware == "goldfish"
|| buildHardware == "vbox86"
|| buildProduct == "sdk"
|| buildProduct == "google_sdk"
|| buildProduct == "sdk_x86"
|| buildProduct == "vbox86p"
|| Build.BOARD.lowercase(Locale.getDefault()).contains("nox")
|| Build.BOOTLOADER.lowercase(Locale.getDefault()).contains("nox")
|| buildHardware.lowercase(Locale.getDefault()).contains("nox")
|| buildProduct.lowercase(Locale.getDefault()).contains("nox"))
if (result) return true
result = result or (Build.BRAND.startsWith("generic") &&
Build.DEVICE.startsWith("generic")) if (result) return true
result = result or ("google_sdk" == buildProduct) return result
}

Пример проверки на Flutter :
checkIsEmu() async {
final devinfo = DeviceInfoPlugin();
final em = await devinfo.androidInfo;
var phoneModel = em.model;
var buildProduct = em.product;
var buildHardware = em.hardware;
var result = (em.fingerprint.startsWith("generic") ||
phoneModel.contains("google_sdk") ||
phoneModel.contains("droid4x") ||
phoneModel.contains("Emulator") ||
phoneModel.contains("Android SDK built for x86") ||
em.manufacturer.contains("Genymotion") ||
buildHardware == "goldfish" ||
buildHardware == "vbox86" ||
buildProduct == "sdk" ||
buildProduct == "google_sdk" ||
buildProduct == "sdk_x86" ||
buildProduct == "vbox86p" ||
em.board.toLowerCase().contains("nox") ||
em.bootloader.toLowerCase().contains("nox") ||
buildHardware.toLowerCase().contains("nox") ||
buildProduct.toLowerCase().contains("nox"));
if (result && !em.isPhysicalDevice) return true;
result = result ||
(em.brand.startsWith("generic") && em.device.startsWith("generic"));
if (result && !em.isPhysicalDevice) return true;
result = result || ("google_sdk" == buildProduct);
return result && !em.isPhysicalDevice;
}

2. Тестирование приложения
● Проверяем апи и сдк версия должна быть с 21 - (31 или 32)

![alt text](https://i.ibb.co/0BSn1df/testingsourceslol.png)

● В вебвью работает поиск и клавиатура
● Сам вебвью работает быстро
● В BUILD.GRADLE добавляем minsdk - 21, targetSdk - 31 или 32 , compilesdk
- 31 или 32
● Локальная ссылка сохраняется
● Кнопка назад возвращает на предыдущую страницу, но на
стартовой странице в вебвью никак не реагирует
● Иконка приложения содержит нужный логотип
● Сгенерирован релиз файл ааб и подписан сертификатом

3. Вопрос - Ответ
- Возможна ли предоплата за проект? Нет.
- Заглушку нужно сделать с функционалом или просто заглушку? Заглушка +
функционал логики.
- Оплата за проект или за час работы?Оплата фиксированная.
- Каким способом происходит оплата? Перевод на карту.
- После чего происходит оплата? После отправки приложения на публикацию.
- Есть ли аппбар на странице вебвью? Нет.
- На чьем устройстве производим сборку релиза ааб и создание ключа? На
устройстве разработчика.
- Если после успешного прохождения ТЗ не получил оффер на постоянную
основу, можем предложить работу на фриланс основе, сдельная оплата за
приложение в зависимости от заглушки, расценки расписаны в самом ТЗ.

Версия компилятора sdk 33 так зависит библиотека mobile_number: ^2.1.1 и другие.

Эта версия реализованного тз при запуске на эмуляторе (не x86, а x86 - устаревшый формат) выдаст ошибку - запускать, чтобы тестировать игру 'заглушку', только на реальном устройстве.

В последнем коммите unity убран (не полностью - остались следы в виде пары записей в androidmanifest)

Из демо суб-проекта https://pub.dev/packages/flutter_unity_widget вырезан ar vr модуль, для успешной компиляции для платформ не поддерживающих opengles 3.0 (для обратной совместимости с opengles 2.0)

Game engine unity 3d 2022.1.13f1 
Android ndk 21.3.6528147
IDE android studio dolphin | 2021.3.1 Patch 1 
OS Windows 10


