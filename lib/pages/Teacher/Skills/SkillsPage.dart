import "package:assessments_app/utils/Competences.dart";

import 'package:assessments_app/pages/Teacher/Skills/CompetencePicked.dart';
import 'package:assessments_app/pages/Teacher/Skills/SkillsCreatePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'dart:convert';

class SkillsPage extends StatefulWidget {
  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  final CollectionReference _competences =
      FirebaseFirestore.instance.collection(getCompetencesPath());

  String? currentUser = FirebaseAuth.instance.currentUser!.email;
  // final vari = jsonDecode(
  // '{"Pensamiento Crítico":{"Name":"Pensamiento Crítico","Mostrar espíritu crítico":["1 - No parece cuestionar información, situaciones o condiciones de la propia vida.","2 - Cuestiona visiblemente ciertas informaciones y situaciones de la propia vida.","3 - Muestra una actitud crítica ante la información recibida y las condiciones de la propia vida.","4 - Explora e investiga el mundo que le rodea. Demuestra ser reflexivo sobre la información adquirida y la propia vida.","5 - Demuestra formular juicios y evaluaciones personales basados en una reflexión sistemática."],"Distinguir los hechos de las opiniones, interpretaciones, valoraciones, etc. en la argumentación de los demás":["1 - Presenta juicios o decisiones personales basados en opiniones e interpretaciones personales como si fueran hechos objetivos.","2 - Acepta sin cuestionar juicios o decisiones basados en opiniones e interpretaciones personales ajenas como si fueran hechos objetivos.","3 - Cuestiona juicios o decisiones basados en opiniones e interpretaciones personales.","4 - Demuestra ser capaz de distinguir los hechos objetivos de las opiniones e interpretaciones personales.","5 - Demuestra reconocer, cuestionar y analizar juicios o decisiones basados en opiniones e interpretaciones personales."],"Participar activamente en el debate":["1 - Permanece pasivo durante los debates.","2 - Se esfuerza por participar en los debates.","3 - Participa activamente en los debates.","4 - Participa constructivamente en los debates, contribuyendo a enriquecer las reflexiones compartidas.","5 - Participa constructivamente en los debates sirviendo de referencia a los demás."],"Prever las implicaciones prácticas de las decisiones y planteamientos":["1 - No parece ser consciente de los efectos de las decisiones y propuestas.","2 - Parece ignorar las implicaciones prácticas de las decisiones y propuestas.","3 - Demuestra prever las implicaciones prácticas de las decisiones y propuestas.","4 - Analiza los pros y los contras de los efectos de las decisiones y propuestas. ","5 - Evalúa adecuadamente los pros y los contras de las decisiones y propuestas."],"Reflexionar sobre las consecuencias y efectos de las propias decisiones en los demás":["1 - No parece preocuparse ni pensar en las consecuencias de las acciones personales sobre los demás.","2 - Escucha las observaciones y críticas de los demás, pero no parece reflexionar sobre ellas. ","3 - Parece escuchar y reflexionar sobre las consecuencias y efectos de las acciones personales en los demás.","4 - Escucha críticamente las opiniones de los demás y reconoce y acepta los errores personales.","5 - Pide, pondera y considera las opiniones de los demás sobre su conducta personal de forma crítica y constructiva."]},"Creatividad":{"Name":"Creatividad","Contribuye con sugerencias a las ideas, situaciones, casos o problemas planteados.":["1 - No contribuye con sugerencias o no lo hace de forma independiente.","2 - Contribuye con sugerencias limitadas y sólo cuando se le requiere.","3 - Contribuye activamente con sugerencias propias ante problemas o situaciones. ","4 - Genera una serie de ideas y/o soluciones a los problemas planteados.","5 - Genera una gran cantidad de ideas alternativas, de forma espontánea y antes de ser requerido para ello. "],"Propone ideas innovadoras en cuanto a contenidos, desarrollo, etc.":["1 - Duda a la hora de considerar o proponer nuevas ideas.","2 - Propone ideas que no contienen nada nuevo.","3 - Propone ideas innovadoras.","4 - Propone mejoras innovadoras para los procesos en los que participa.","5 - Destaca por sus aportaciones innovadoras."],"Reconoce formas diferentes de hacer las cosas; es inconformista.":["1 - No parece cuestionar su propia situación o circunstancias. Se limita a trabajar según los patrones establecidos. ","2 - Parece cuestionarse las cosas pero no hace nada para cambiar su propia situación.","3 - Parece darse cuenta de que hay varias maneras de hacer las cosas. Es algo inconformista.","4 - Cuestiona las formas tradicionales de hacer las cosas y prueba nuevas formas de mejorar.","5 - Detecta situaciones que pueden mejorarse y propone soluciones innovadoras."],"Genera nuevas ideas o soluciones a situaciones o problemas a partir de lo conocido.":["1 - No aplica los conocimientos propios en diferentes campos.","2 - Aplica los conocimientos propios en diferentes campos pero no presenta nuevas ideas personales como resultado.","3 - Presenta ideas valiosas o soluciones prácticas que han funcionado en otros contextos.","4 - Genera ideas nuevas/ analogías con otras situaciones o problemas experimentados previamente. ","5 - Genera ideas valiosas o soluciones prácticas que han funcionado en otros contextos y las adapta en los otros contextos."],"Transmite o hace llegar a otros las nuevas ideas generadas.":["1 - No expresa ideas personales nuevas.","2 - Expresa ideas personales, aunque con dificultad.","3 - Expresa y transmite a otros nuevas ideas personales.","4 - Comparte nuevas ideas personales y se esfuerza por hacerlas comprensibles a los demás.","5 - Comparte nuevas ideas de forma comprensible y fomenta un ambiente creativo."]},"Comunicación Interpersonal":{"Name":"Comunicación Interpersonal","Escuchar atentamente No parece escuchar atentamente. Intenta imponer sus ideas a los demás.":["1 - Parece distraerse con facilidad y no captar todo el mensaje.","2 - Muestra concentración e interés al escuchar a los demás.","3 - Escucha activamente a los demás demostrando intentar comprender plenamente las ideas de los demás.","4 - Escucha activamente a los demás respetando su propio tiempo para demostrar que se le escucha.","5 - Escucha activamente a los demás respetando su propio tiempo para demostrar que se les escucha."],"Decir lo que uno piensa y siente sobre un tema.":["1 - No parece expresar pensamientos personales.","2 - No adopta una postura y los mensajes expresados son ambiguos.","3 - Expresa pensamientos y sentimientos sobre el tema tratado.","4 - Expresa pensamientos y sentimientos libremente, con claridad y seguridad.","5 - Es asertivo. Deja claro a los demás cuál es la postura personal sobre el tema en cuestión."],"Habla de las cosas de forma empática e igualitaria.":["1 - Parece evaluar y juzgar con frecuencia lo que dicen los demás; actúa a la defensiva.","2 - Habla con excesivo sentido de seguridad y superioridad.","3 - Parece evitar hacer juicios de valor o transmitir un sentimiento de superioridad al hablar.","4 - Cuando se comunica, tiene en cuenta a los demás y les apoya.","5 - Al comunicarse, promueve la comprensión y el diálogo. "],"Hace preguntas para comprender mejor.":["1 - No hace preguntas y parece dar por supuesto que ha entendido lo que dicen los demás.","2 - Hace pocas preguntas de forma inoportuna o poco estructurada.","3 - Hace preguntas abiertas para comprender las ideas y posturas de los demás.","4 - Formula preguntas que permiten un flujo natural, contribuyendo a ampliar la conversación.","5 - Formula preguntas que mejoran el ambiente o ayudan a que el diálogo avance."],"Expresarse con claridad y precisión.":["1 - La expresión de sí mismo es vaga o poco clara.","2 - Se expresa de forma vacilante y sin conseguir transmitir las ideas de forma clara.","3 - Transmite ideas de forma concisa cuando se encuentra en contextos familiares.","4 - Expresa ideas con facilidad y fluidez en diferentes contextos.","5 - Muestra una facilidad de expresión y una comunicación clara en general sobresalientes."]},"Colaboración – Trabajo En Equipo":{"Name":"Colaboración – Trabajo En Equipo","Completa las tareas asignadas dentro del plazo como miembro del grupo.":["1 - No completa las tareas asignadas.","2 - Completa parcialmente las tareas asignadas o lo hace con retrasos.","3 - Respeta los plazos e informa sobre el progreso de la tarea asignada.","4 - Respeta los plazos y el trabajo entregado supone una gran contribución al equipo.","5 - Además de completar bien la tarea asignada, el trabajo realizado facilita la labor de los demás miembros del equipo."],"Participa activamente en las reuniones de equipo, compartiendo información, conocimientos y experiencias.":["1 - A menudo se ausenta / no contribuye al trabajo del grupo.","2 - Participa poco y contribuye sobre todo a petición de los demás.","3 - En general, es activo y participativo en los encuentros de grupo.","4 - Las contribuciones fomentan la participación y la mejora de la calidad de los resultados del equipo.","5 - Las contribuciones son fundamentales para el trabajo en equipo y para la calidad de los resultados."],"Colabora en la definición, organización y distribución de las tareas del grupo.":["1 - No colabora en la organización del trabajo en equipo.","2 - Acepta sin cuestionar el plan de trabajo propuesto por otros miembros del equipo.","3 - Participa activamente en la planificación, organización y distribución del trabajo en equipo.","4 - Es organizado y eficaz en la planificación, organización y distribución de las tareas del grupo.","5 - Fomenta la organización del trabajo aprovechando los talentos y conocimientos de los demás."],"Centrarse y comprometerse con el acuerdo y los objetivos compartidos Parece centrarse únicamente en los objetivos personales.":["1 - Intenta integrar los objetivos personales y compartidos, pero no lo consigue.","2 - Tiene en cuenta los objetivos del grupo y los suyos propios.","3 - Participa en la definición clara de los objetivos del grupo, teniendo en cuenta a todos los miembros del grupo.","4 - Centrarse y comprometerse con el acuerdo y los objetivos compartidos Parece centrarse únicamente en los objetivos personales.","5 - Motiva y guía al grupo hacia objetivos más exigentes. Los grupos en los que participa destacan por su rendimiento y calidad."],"Considerar el punto de vista de los demás y dar una opinión constructiva.":["1 - Parece no escuchar atentamente a los compañeros y subestimarlos sistemáticamente imponiendo sus propias opiniones.","2 - Intenta escuchar, pero no hace preguntas y no parece tener en cuenta las opiniones de los demás. Las aportaciones son redundantes y poco sugerentes.","3 - Acepta las opiniones de los demás y sabe dar su propio punto de vista de forma constructiva. ","4 - Promueve diálogos constructivos e inspira una participación de calidad de los demás miembros del grupo.","5 - Integra las opiniones de los demás en una perspectiva superior, manteniendo una atmósfera de colaboración y apoyo."]},"Resolución De Problemas":{"Name":"Resolución De Problemas","Identificar un problema y tomar la decisión de abordarlo.":["1 - No parece darse cuenta de que existe un problema.","2 - Se da cuenta de que existe un problema, pero le cuesta identificarlo concretamente.","3 - Identifica activamente los problemas, pero permanece pasivo ante ellos.","4 - Identifica fácilmente los problemas y adopta una actitud proactiva ante ellos.","5 - Identifica los problemas, explicando concretamente cómo lo hace, y demuestra una actitud proactiva para abordarlos.  "],"Hace preguntas para definir el problema en cuestión.":["1 - No participa en la definición del problema.","2 - Ocasionalmente hace preguntas para definir el problema.","3 - Formula preguntas adecuadas para definir el problema.","4 - Participa activamente en la formulación de preguntas para definir el problema.","5 - Formula preguntas clave para definir el problema y evaluar su importancia. "],"Recopila información relevante de fuentes fiables, siguiendo un método lógico de análisis de la información.":["1 - No recopila información o la información recopilada es irrelevante o poco fiable. ","2 - Recopila información pertinente, pero a veces incompleta o poco fiable, y no siempre sigue un método de análisis. ","3 - Recopila la información necesaria y la analiza correctamente.","4 - Selecciona con precisión información valiosa y fiable y la analiza sistemáticamente.","5 - Recopila eficazmente información pertinente y fiable y la analiza con un método eficaz y aportando reflexiones. "],"Presenta diferentes soluciones a un mismo problema y evalúa los posibles riesgos y ventajas de cada una de ellas.":["1 - No presenta más de una solución para un problema.","2 - Presenta ocasionalmente soluciones alternativas. ","3 - Presenta algunas alternativas y un sencillo análisis de pros y contras. ","4 - Presenta un buen análisis de las soluciones alternativas disponibles.","5 - Elige una o varias soluciones eficaces, basándose en el análisis de las distintas opciones."],"Diseña un plan de acción para aplicar la solución elegida.":["1 - No propone soluciones o las que propone no se basan en un planteamiento lógico.","2 - Propone soluciones, pero no planifica una aplicación.","3 - Es capaz de seleccionar soluciones basándose en una argumentación sólida y es capaz de aplicar un plan basado en la solución propuesta.","4 - Es capaz de proponer múltiples soluciones y seleccionarlas de acuerdo con una argumentación sólida y es capaz de aplicar un plan basado en la solución propuesta.","5 - Es capaz de proponer múltiples soluciones y seleccionarlas de acuerdo con una argumentación sólida y es capaz de diseñar y aplicar un plan basado en la solución propuesta."]},"Diversidad E Inteculturalidad":{"Name":"Diversidad E Inteculturalidad","Aceptar la diversidad como parte de la condición humana.":["1 - Parece considerar la diversidad como una barrera entre las personas.","2 - Parece tratar a las personas de forma diferente, basándose en diferencias cognitivas, de género, sociales y culturales.","3 - La actitud hacia los demás no parece estar limitada o influida por diferencias cognitivas, de género, sociales o culturales.","4 - Establece relaciones sociales sin barreras ni prejuicios basadas en la diversidad humana.","5 - Adopta una actitud equitativa, promoviendo un entorno social que acoge la diversidad humana."],"Se relaciona con las personas sin distinción / prejuicio de origen social y cultural.":["1 - Manifiesta aversión hacia las personas de orígenes sociales o culturales diversos.","2 - Muestra cierto nivel de desconfianza /prejuicios hacia personas y prácticas de orígenes sociales o culturales diferentes.","3 - Muestra respeto hacia personas de distinto origen social o cultural.","4 - Establece relaciones sin sentirse limitado por las diferencias culturales o sociales de otras personas.","5 - Aprecia las diferencias culturales y sociales y valora a las personas por sus cualidades personales. "],"No discrimina a las personas por razones de diferencia cognitiva, de género, social o cultural.":["1 - Parece menospreciar a las personas con diferencias cognitivas, de género, sociales y/o culturales.","2 - Muestra cierto nivel de prejuicio/discriminación hacia las personas con diferencias cognitivas, de género, sociales y/o culturales.","3 - Actúa con respeto hacia las personas con diferencias cognitivas, de género, sociales y/o culturales.","4 - Su actitud personal muestra aceptación por la diversidad humana y las prácticas sociales de otras personas. ","5 - Respeta y se esfuerza por comprender las diferentes costumbres y comportamientos sociales de los seres humanos."],"Establece relaciones con personas diferentes para su desarrollo personal.":["1 - No se relaciona con personas diferentes a él por prejuicios.","2 - Parece asumir que las relaciones humanas deben basarse en similitudes cognitivas, de género, sociales y/o culturales.","3 - Parece relacionarse con personas independientemente de sus diferencias cognitivas, de género, sociales y/o culturales.","4 - Parece apreciar los entornos diversos y explorar activamente puntos de vista, pensamientos e ideas alternativos. para el desarrollo personal Promueve activamente un entorno humano rico y diverso que favorezca el desarrollo personal de todos los implicados.","5 - Promueve activamente un entorno humano rico y diverso que favorezca el desarrollo personal de todos los implicados."],"Comprende el valor añadido de la diversidad humana.":["1 - Parece considerar la diversidad cognitiva, de género, social y/o cultural como justificación de la desigualdad de acceso a las oportunidades sociales.","2 - Parece considerar los valores personales como los únicos válidos en los que basar las relaciones.","3 - Parece escuchar e interpretar respetuosamente los valores de los demás.","4 - La actitud personal demuestra una aceptación de los valores de los demás.","5 - La actitud personal demuestra una integración equilibrada entre los valores personales y los de otras personas de su entorno."]},"Comunicación Oral":{"Name":"Comunicación Oral","Participa en situaciones de habla.":["1 - No habla, aunque se le pida.","2 - Apenas habla cuando se le pide.","3 - Habla largo y tendido cuando se le pide.","4 - Habla por iniciativa propia en momentos apropiados.","5 - Destaca por hacer aportaciones adecuadas por iniciativa propia."],"Transmite información importante.":["1 - No presenta ideas o la expresión es pobre y confusa. ","2 - Presenta algunas ideas.","3 - Expresa ideas bien razonadas.","4 - Expresa ideas bien razonadas, sentimientos y valores.","5 - Destaca por la claridad de expresión relacionada con el razonamiento y/o los sentimientos."],"Controla los nervios al hablar en público.":["1 - Le cuesta hablar aparentemente debido a los nervios; parece sentirse bloqueado.","2 - Habla, pero se muestra notablemente nervioso e incómodo.","3 - Se expresa mostrando cierta tranquilidad. ","4 - Se expresa con seguridad.","5 - Se expresa con una actitud tranquila y un dominio notable. "],"Imparte charlas estructuradas, cumpliendo los requisitos que puedan existir.":["1 - Las charlas pronunciadas carecen de estructura inteligible.","2 - La estructura de las charlas no es eficaz o no cumple los requisitos estipulados.","3 - Las charlas están estructuradas, cumpliendo los requisitos estipulados, si existen.","4 - Enlaza ideas y argumentos con facilidad al pronunciar una charla.","5 - Presenta charlas eficaces y bien organizadas."],"Responde a las preguntas.":["1 - No responde a las preguntas formuladas.","2 - Responde a las preguntas formuladas sin contestarlas.","3 - Responde superficialmente a las preguntas formuladas.","4 - Responde a las preguntas formuladas de forma eficaz y articulada.","5 - Responde bien y con aparente facilidad a las preguntas formuladas."]},"Comunicación Escrita":{"Name":"Comunicación Escrita","Trata un tema específico, sin desviarse hacia otro.":["1 - Mezcla varios temas sin aclarar cuál es el principal.","2 - Alarga los textos con repeticiones o divagaciones innecesarias.","3 - Se centra en el tema sin regresiones.","4 - Cubre todos los aspectos del tema según las instrucciones.","5 - Aborda el tema en profundidad, más allá de lo requerido."],"Expresa con claridad ideas, conocimientos o sentimientos.":["1 - Los textos escritos son confusos y muy difíciles de seguir. ","2 - La expresión puede entenderse, pero la redacción es desorganizada.","3 - Presenta los diferentes aspectos del tema en un orden lógico.","4 - La expresión escrita es buena, lógica y organizada (por ejemplo, incluye introducción, desarrollo y conclusión al escribir ensayos).","5 - Expresión escrita sobresaliente y lógica, con una organización eficaz de los párrafos y apartados."],"Escribe bien gramaticalmente.":["1 - Al escribir, no sigue las reglas gramaticales correctas.","2 - Sigue las reglas gramaticales correctas, pero comete faltas de ortografía relevantes.","3 - Los textos escritos son correctos en cuanto a ortografía y gramática.","4 - Los textos son correctos en lo que respecta a la ortografía y la gramática y están correctamente puntuados.","5 - Además de seguir las reglas gramaticales y ortográficas correctas, utiliza bien las preposiciones y conjunciones. "],"Utiliza un lenguaje adecuado al tipo de documento y de lector.":["1 - Utiliza abreviaturas o jerga inadecuadas.","2 - Utiliza incorrectamente la terminología propia del tema.","3 - Utiliza la terminología adecuada al tema. ","4 - Utiliza correctamente la terminología propia del tema y la adapta según el documento y el lector.","5 - Utiliza sinónimos para aclarar términos ambiguos o equívocos, según el tipo de documento o de lector final."],"Utiliza los recursos adecuados para facilitar la lectura y comprensión del ensayo.":["1 - No da formato al texto (tipo de letra, párrafo, estilo, formatos, etc.). No enumera las páginas.","2 - Utiliza excesivamente los dispositivos de formato, dificultando la comprensión.","3 - Utiliza adecuadamente los dispositivos tipográficos (fuente, párrafo, formatos de estilo, etc.).","4 - Formatea adecuadamente el texto y utiliza notas a pie de página o notas finales para referencias, comentarios, etc. ","5 - Organiza y formatea claramente el ensayo y todos sus elementos clave."]},"Orientación Al Aprendizaje":{"Name":"Orientación Al Aprendizaje","Pone en práctica de forma disciplinada los planteamientos, métodos y experiencias propuestos por el profesor.":["1 - No sigue / parece ignorar las propuestas del profesor.","2 - Interpreta o aplica inadecuadamente las propuestas del profesor.","3 - Sigue adecuadamente las propuestas del profesor en el proceso de aprendizaje.","4 - Prioriza las propuestas del profesor de la forma más adecuada a los objetivos de aprendizaje.","5 - Participa activamente en la creación y selección de estrategias para alcanzar los objetivos de aprendizaje."],"Comparte y asume los objetivos de aprendizaje propuestos por el profesor.":["1 - Parece ignorar los objetivos de aprendizaje propuestos por el profesor.","2 - Malinterpreta los objetivos de aprendizaje propuestos por el profesor.","3 - Comprende y asume los objetivos de aprendizaje propuestos por el profesor.","4 - Prioriza con buen criterio los objetivos de aprendizaje propuestos por el profesor.","5 - Realiza cambios personales adecuados a los objetivos de aprendizaje propuestos por el profesor."],"Hace preguntas para comprender la información y complementarla para aprender más.":["1 - No formula preguntas en relación con la información recibida.","2 - Realiza preguntas sólo cuando se lo pide el profesor o para resolver problemas concretos.","3 - Plantea preguntas sobre la información recibida, con el fin de comprender mejor el tema.","4 - Plantea preguntas que demuestran una buena comprensión de lo aprendido. ","5 - Plantea preguntas que van más allá del tema, para complementar la información recibida con el fin de aprender más."],"Reconoce la importancia de los esquemas mentales de los demás para enriquecer el aprendizaje.":["1 - Muestra poco interés por intercambiar ideas con los demás.","2 - Le gusta compartir ideas personales, pero defiende posiciones personales, prestando poca o ninguna consideración a las ideas de los demás.","3 - Parece escuchar con interés las ideas propuestas por los compañeros y por el profesor.","4 - Pregunta por las perspectivas y opiniones de los demás, en relación con los temas que se están estudiando.","5 - Promueve el intercambio y la argumentación de opiniones, para enriquecer y avanzar en el aprendizaje. "],"Aprendizaje autónomo y autorregulado.":["1 - No muestra iniciativa en el proceso de aprendizaje y sigue de forma incompleta las propuestas del profesor. ","2 - Completa las propuestas del profesor, pero con el mínimo esfuerzo.","3 - Completa las propuestas del profesor con motivación y esfuerzo.","4 - Va más allá de las propuestas del profesor, completando las tareas con añadidos que las mejoran más allá de lo requerido.","5 - Va más allá de las propuestas del profesor, tratando de profundizar en el mismo tema o en otros para aprender más."]},"Sentido Ético":{"Name":"Sentido Ético","Guiar el comportamiento personal por un conocimiento básico de los principios éticos.":["1 - Parece actuar sin considerar si las acciones personales son moralmente correctas o incorrectas. ","2 - Sigue pero no parece cuestionar las razones que subyacen a algunos principios éticos básicos.","3 - Muestra una conducta moral y expresa opiniones morales muy básicas cuando se aplica un principio.","4 - Parece actuar de acuerdo con un juicio moral bien razonado y apoyado en el conocimiento de los principios éticos.","5 - Actúa de forma moral coherente, argumentando con ideas bien razonadas que implican principios éticos, lo que le lleva a una conclusión moral."],"Busca afirmarse a través del conocimiento del mundo ético.":["1 - No parece estar interesado en el origen, razonamiento o implicaciones de los principios éticos básicos.","2 - Muestra dificultad para guiar y motivar el comportamiento personal de acuerdo con los principios éticos.","3 - Sigue principios éticos básicos y muestra conciencia de la dimensión ética del ser humano.","4 - Construye argumentos lógicos en torno a principios éticos y su aplicación en diferentes situaciones.","5 - Expresa una idea personal de la ética coherente y bien razonada (de acuerdo con la percepción y el desarrollo de la conciencia moral)."],"Acepta críticamente nuevas perspectivas, aunque pongan en duda las propias.":["1 - No aborda las cuestiones éticas en toda su complejidad (es decir, todas las implicaciones, circunstancias y consecuencias que conllevan).","2 - Parece considerar únicamente la perspectiva personal o la de los directamente implicados durante una acción, pasando por alto otros puntos de vista relevantes.","3 - Demuestra una postura crítica sobre lo que es correcto, utilizando criterios razonados basados en puntos de vista personales y en los de los demás.","4 - Demuestra comprensión y apertura a las necesidades e intereses de los demás.","5 - Contribuye constructivamente a la resolución de problemas, respetando y reconociendo las necesidades, sentimientos y opiniones de los demás."],"Posee un sistema de valores personales como parte de su personalidad e identidad.":["1 - No parece pensar ni preocuparse por los valores morales.","2 - Menciona valores, pero sin asumirlos consciente y deliberadamente como propios.","3 - Manifiesta valores personales a los demás como parte de la identidad personal.","4 - Tiene una organización clara de los valores personales según su importancia y prioridad.","5 - Demuestra un sistema de valores personales coherente basado en el reconocimiento de principios éticos."],"Observa y pone en práctica las normas establecidas por el grupo/contexto educativo al que pertenece.":["1 - No parece ser consciente de las normas establecidas por el grupo/contexto educativo.","2 - Muestra reconocimiento de las normas establecidas por el grupo/contexto educativo, pero le cuesta seguirlas de forma coherente.","3 - Reconoce y respeta las normas establecidas por el grupo/contexto educativo.","4 - Parece intentar interpretar y dar sentido a cada uno de los elementos normativos establecidos por el contexto grupal/educativo.","5 - Demuestra un proceso de reflexión que le lleva a tomar conciencia de los aspectos normativos y de su papel a la hora de proporcionar un horizonte moral."]},"Gestión De Proyectos":{"Name":"Gestión De Proyectos","Describe la situación que justifica la necesidad del proyecto.":["1 - No parece ser consciente de las necesidades que aborda el proyecto ni de los temas implicados.","2 - Identifica los temas del proyecto y los elementos implicados, pero no los relaciona con las necesidades que pretende abordar. ","3 - Contextualiza el proyecto y sus elementos, aludiendo a las necesidades que pretende abordar.","4 - Justifica el proyecto y los elementos implicados estableciendo un vínculo claro con las necesidades abordadas.","5 - Justifica la necesidad del proyecto de forma clara y organizada con el apoyo de pruebas pertinentes."],"Establece objetivos claros para el proyecto.":["1 - No formula objetivos para el proyecto o los formula de forma poco clara.","2 - Formula objetivos pero no los relaciona con las necesidades abordadas.","3 - Formula objetivos claros y los relaciona con las necesidades abordadas por el proyecto.","4 - Formula objetivos claros y bien razonados que son realistas y factibles.","5 - Formula objetivos realistas y ambiciosos que abordan las necesidades del proyecto y va más allá del esfuerzo necesario para alcanzarlos."],"Planifica acciones para alcanzar los objetivos y dirige a las personas responsables de ellas.":["1 - Considera los objetivos sin especificar las acciones necesarias para alcanzarlos. ","2 - Define acciones pero no las asigna a personas.","3 - Define acciones concretas y especifica quién las llevará a cabo.","4 - Planifica cuidadosamente las acciones, sopesando su viabilidad y especificando los responsables.","5 - Establece una secuencia excelente de acciones y las asigna a la persona o personas más adecuadas."],"Prevé y asigna el tiempo necesario para completar las acciones planificadas.":["1 - No considera el tiempo necesario para cada acción.","2 - Calcula el tiempo necesario para cada acción de forma poco realista.","3 - Planifica detalladamente el tiempo para cada acción.","4 - Realiza un plan de tiempo bien pensado y añade tiempo adicional en caso de imprevistos.","5 - Establece mecanismos para controlar el tiempo y hacer los ajustes necesarios como parte de un plan de acción claro."],"Planifica la evaluación de los resultados del proyecto.":["1 - Pasa por alto la importancia de evaluar los resultados del proyecto.","2 - Parece ser consciente de la importancia de evaluar los resultados, pero no presenta un plan para hacerlo.","3 - Proporciona un plan de evaluación general, que incluye cuándo y cómo se realizará la evaluación y quién la realizará.","4 - Planifica sistemáticamente cuándo y cómo se realizará la evaluación y quién la realizará.","5 - Planifica sistemáticamente cuándo y cómo se realizará la evaluación y quién la realizará, definiendo los indicadores pertinentes y las herramientas que se utilizarán."]}}');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _competences.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser)
              .collection('PrivateCompetences')
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshotprivate) {
            if (snapshotprivate.hasError) {
              return Text("Something went wrong");
            }
            if (!snapshotprivate.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.competences),
                centerTitle: true,
                backgroundColor: Color(0xFF29D09E),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Color(0xFF29D09E),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SkillsCreatePage(),
                    ),
                  );
                },
              ),
              body: SafeArea(
                child: ListView(
                  children: snapshotprivate.data!.docs.map(
                        (DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return ListTile(
                            textColor: Color(0xFF29D09E),
                            visualDensity: VisualDensity.standard,
                            trailing: Wrap(
                              direction: Axis.horizontal,
                              spacing: 10,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                  title:
                                                      Text("Remove Competence"),
                                                  content: Text(
                                                      'Remove the indicators regarding this competence forever?'),
                                                  actions: [
                                                    TextButton(
                                                      style: ButtonStyle(
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    Colors
                                                                        .blue),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .cancel),
                                                    ),
                                                    TextButton(
                                                      style: ButtonStyle(
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    Colors
                                                                        .blue),
                                                      ),
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .delete),
                                                      onPressed: () async {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection("users")
                                                            .doc(currentUser)
                                                            .collection(
                                                                'PrivateCompetences')
                                                            .doc(data['Name'])
                                                            .delete()
                                                            .then(
                                                              (doc) => print(
                                                                  "Document deleted"),
                                                              onError: (e) => print(
                                                                  "Error updating document $e"),
                                                            );
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                    ),
                                                  ]));

                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CompetencePicked(
                                                passedComp: data,
                                                passedName: data['Name'],
                                                editable: true,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                            Icons.arrow_circle_right_rounded),
                                      );
                                    })
                              ],
                            ),
                            title: Text(
                              data['Name'],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompetencePicked(
                                    passedComp: data,
                                    passedName: data['Name'],
                                    editable: true,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ).toList() +
                      snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return ListTile(
                            visualDensity: VisualDensity.standard,
                            trailing: Wrap(
                              direction: Axis.horizontal,
                              spacing: 10,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CompetencePicked(
                                            passedComp: data,
                                            passedName: data['Name'],
                                            editable: false,
                                          ),
                                        ),
                                      );
                                    },
                                    icon:
                                        Icon(Icons.arrow_circle_right_rounded)),
                              ],
                            ),
                            title: Text(
                              data['Name'],
                            ),
                          );
                        },
                      ).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
