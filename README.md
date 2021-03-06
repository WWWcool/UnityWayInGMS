# UnityWayInGMS

[Посетите Вики для другой, но тоже интересной информации](https://github.com/WWWcool/UnityWayInGMS/wiki)

[Ссылка на документацию извлеченную из проекта](https://wwwcool.github.io/UnityWayInGMS/index.html)

## Резюме
UnityWay - это попытка создать расширяемую инфраструктуру для кодовой базы в рамках синтаксиса и особенностей движка GameMakerStudio 2 и его языка GML.
Основная мотивация - это используя новые фичи языка попытаться принести на платформу некоторые инструменты из других движков, областей, решить стандартные проблемы возникающие у разработчиков на разных платформах, обобщить этот опыт и передать его всем пользователям этого движка.
Кроме этого, в отличие от многих ассетов и библиотек в маркете или гитхабе есть желание минимизировать глобальные методы этой кодовой базы, чтобы понизить порог вхождения и упростить использование.

*Примечание 1*

Далее по тексту все структуры языка GML будут называться классами

*Примечание 2*

Подробно стиль написание кода будет описан в разделе кодовая политика, но хочется отметить, что основная мысль следующая - глобальные методы есть публичное API предоставляемое различными библиотеками или их сочетаниями, при этом все вспомогательные методы и функции скрыты внутри классов, таким образом достигается минимизация доступных функций для неопытных пользователей и остается полная свобода для опытных.

*Примечание 3*

В этом документе нет описания методов классов, а дана информация о мыслях и концепциях заложенных в эти классы

*Примечание 4*

Это альфа версия проекта, было мало отладки, поэтому багов хватает, но если проект найдет свою аудиторию, то количество багов будет уменьшаться)


### Содержание:

- [Структура проекта](#Структура)
- [UWObject](#UWObject)
- [UWComponent](#UWComponent)
- [UWComponentGroup](#UWComponentGroup)
- [UWVector2](#UWVector2)
- [UWTransform](#UWTransform)
- [UWSpriteRenderer](#UWSpriteRenderer)
- [Зависимости](#Зависимости)
- [PrefabBuilder](#PrefabBuilder)
- [Добавление пользовательских компонентов](#Добавление)
- [Что дальше?](#Roadmap)
- [Кодовая политика](#Политика)
- [Участие в проекте](#Участие)

## Структура
Все ресурсы собраны в папке UnityWay, при этом в каждой папке внутри находятся разные приложения:
- Папка Core - это базовые компоненты системы
- Папка PrefabBuilder - приложение для создание объектов на основе информации из секвенций

Если проект будет развиваться, то здесь могут появиться папки для приложений визуального создания и редактирования диалогов, деревьев поведения, аниматоров и тд. 

**Важно!** Чтобы базовые компоненты и скрипты на них основанные корректно работали необходимо, чтобы объекты их использующие наследовались от объекта __uw_object, находящегося в папке UnityWay/Core/Components

## UWObject
Класс контейнер для компонентов и методов работы с ними. Является сердцем объектов наследованных от __uw_object, но может существовать и самостоятельно в виде структуры данных, что позволяет делать сложные иерархии в коде используя все методы библиотек и классов, при этом существуя в рамках одного экземпляра игрового объекта.
В теории можно существовать и без привязки к объекту, но для этого нужно агрегировать выполнение событий (групп компонентов)

## UWComponent
Базовый класс для компонентов в системе, именно его наследников добавляют в UWObject и именно в них сосредоточена основная игровая логика. В чем смысл делать такие компоненты, а не писать код привычным для GMS способом располагая его в событиях объекта или функциях, классах. По задумке, компоненты должны помочь предсказуемо переиспользовать композицию для построения сложного игрового поведения, при этом ничего не мешает использовать гибридный подход и в каких то случаях писать код в событиях объектов. Использование компонентов добавляет некоторую сложность в написание кода - это цена, за организацию и сегментирование кода, которые за вас выстроили в систему.

## UWComponentGroup
Абстракция призванная объединять компоненты в группу(что и следует из названия). Но что делает эта группа? А вот делает она абсолютно все что угодно! Как это работает? Когда вы создаете игровой объект содержащий UWObject или сам UWObject, то после создания вы можете добавить в него группы, когда новые компоненты будут добавляться к этому объекту, то они будут проверяться на принадлежность каждой группе и в случае если они удоавлетворяют условиям, то добавляться в них. Что это дает? у каждой группы сейчас есть метод исполнения (далее execute), который проделывает некоторые действия со всеми компонентами этой группы. Какие действия - ровно те, которые вы укажете в функции execute, которую передадите при создании группы (к слову для проверки принадлежности передается функция проверки). А что если я хочу добавить группу потом? Все работает точно также - вы добавляете группу, она проверяет на принадлежность все компоненты которые есть в объекте и вы можете дальше работать как обычно. Концепция группы очень гибкая и позволяет по новому взглянуть на работу с компонентами. Например, если у компонента есть поле с именем create_func (предположим, что в нем метод инициализации компонента), то мы понимаем, что его можно причислить к группе CREATE, которая исполняется когда вы вызовете метод execute группы CREATE, например в событии Create игрового объекта и метод execute пройдется по всем компонентам группы и вызовет их метод create_func (сейчас таким образом организованы группы Create, Step, Draw, которые добавляются при создании __uw_object).

## UWVector2
Портированная библиотека для двумерного вектора, помогает в 2д)

## UWTransform
Компонент для описания позиции, вращения и масштаба объекта. Работает как с виртуальными так и с игровыми объектами. Основным назначением являлась организация иерархии объектов, чтобы можно было делать связки, когда один объект расположен относительно другого объекта и сохраняет это положение. Этот компонент имеет базовую роль при построении сложной иерархии и является концепцией заимствованной из других игровых движков. К сожалению простыми средствами в GMS не удалось воиспроизвести поведение характерное для этой системы, поэтому масштабирование древа объектов работает не так как можно ожидать. Есть мысли как его можно докрутить до аналогов, но там возникают проблемы и сложности, в том числе с производительностью, пока не понятно стоит ли допиливать или оставить в таком виде, в надежде что в GMS добавят поддержку подобных функций на уровне движка.

## UWSpriteRenderer
Компонент необходимый для рисования спрайтов виртуальных объектов, кроме этого ничем не занимается, включается в группу Draw при добавлении.

## Зависимости
Чтобы из всей библиотеки компонентов оставлять только те, что нужны для конкретного проекта была разработана система, где в явном виде записаны какие компоненты необходимы для функционирования других. Пользуясь представленной функцией валидации можно проверить добавлены ли в проект все компоненты необходимые для работы уже добавленных. Также систему можно использовать при создании своих библиотек компонентов, чтобы прописывать свои зависимости.

## PrefabBuilder
Интересный эксперимент, который позволяет использовать визуальную сборку объектов в редакторе Sequence, чтобы на старте игры получить из них функции создающие объекты с такой же структурой. Можно создавать как связанную иерархию объектов, так и объекты, где только корень древа иерархии будет игровым объектом, а все остальные будут виртуальными объектами. Чтобы это работало объекты объединяются в древо с помощью компонента трансформ и наследуют все группы компонентов родительского объекта. При помощи редактора Sequence можно быстро создавать сложно связанные объекты, без необходимости большого количества итераций на подбор взаимного расположения, а потом создавать эти объекты так же лекго как и обычные объекты с помощью метода InstanceCreateLayer, объекта UWPrefabFactory, который можно получить из глобального списка префабов формирующегося на старте приложения.

## Добавление
Чтобы создать свой компонент, нужно создать новый скрипт, в нем создать структуру и унаследовать ее от UWComponent, выглядит это примерно так:
```
function YourComponent(_your_args) : UWComponent(COMPONENT_TYPE_ID, COMPONENT_NAME) constructor
{
  // your component code
}
```
При этом:
- COMPONENT_TYPE_ID -- идентификатор компонента, чтобы получать к нему доступ методом UWObject.GetComponentByTypeID, обычно число
- COMPONENT_NAME -- имя компонента, чтобы получать к нему доступ методом UWObject.GetComponentByName

**Важно!** Дизайн системы компонентов так сделан, что в UWObject всегда может быть не более одного компонента заданного типа

## Roadmap
В такую систему можно адаптировать большое количество уже готового кода из маркет плейса и гитхаба, портировать инструменты других движков:
- Подстройка под экран
- Работа с опциями игры
- Небольшие приложения, которые можно запускать в их комнатах, например:
  - Нодовый редактор для конечных автоматов
  - Нодовый редактор для ИИ
  - Редактор для диалогов
  - Редактор частиц
- Игровые и технические системы
  - Жизни и нанесение/получение урона
  - Стандартные снаряды/пули и их столкновения
  - Упрощенная работа с системой частиц
  - Стандартные системы передвижения/столкновения для популярных жанров
  - Поиск пути
  - Система освещения
- Инструменты из других движков
  - Аниматор
  - Материал для UWSpriteRenderer
  - События, подписки
  - Конечные автоматы
  - Внедрение зависимостей

Продолжать список можно очень долго.

## Политика
Стиль кода, в котором написан данный проект:
```
МАКРОСЫ

function имя_функции(_аргументы_функции)
{
    
}

function ИмяОбъекта(_аргументы_конструктора_объекта) : UWComponent(_аргументы_конструктора_объекта_родителя) constructor
{
  локальная_переменная = значение;
  ИмяМетода = function(_аргументы_метода)
  {
    // код
    локальная_переменная = значение;
  }
}
```

## Участие

Если у вас появилось непреодалимое желание помочь развитию проекта делом, то вы всегда можете сделать PullRequest, написать мне в ЛС в [vk](https://vk.com/boo6iiie) или в телеграм @afternao
