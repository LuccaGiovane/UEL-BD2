<div align="center">
  <h1>Atividade: Views, CTE, Window Functions e Desenvolvimento em PL/SQL</h1>
</div><br>

<div>
  <h2>Objetivo</h2>
  <a>Praticar recursos adicionais de SQL (views, common table expressions e window functions) e adquirir proficiência em programação server-side, incluindo funções, procedimentos , tendo o Oracle e PL/SQL como exemplo de uso.</a>

  <h2>Requisitos e Avaliação</h2>
  <a>A atividade é individual.</a><br>
  <a>Cada aluno deverá submeter nesta atividade do Classroom o relatório resultante da sua implementação, que pode ser um arquivo texto (txt) ou documento (docx, odt, Google Docs, etc.).</a><br>
  <a>A atividade tem peso 3 na nota do primeiro bimestre da disciplina, enquanto a prova tem peso 7.</a><br>

  <h2>Descrição</h2>
<a>• Fazer a importação do banco de dados criado para o sistema de exemplo desenvolvido para a disciplina 1COP017 - Bancos de Dados I para o Oracle Database. Inclua no relatório os comandos SQL de criação do banco.</a><br>
<a>• Caso considere conveniente, faça adaptações no modelo para que acomodar melhor as funcionalidades desenvolvidas na presente atividade. Inclua no relatório os comandos SQL que implementam tais adaptações. Esse item é opcional.</a><br>
<a>• Implemente um procedimento em PL/SQL que faça uma carga das tabelas do banco de dados com dados (semi)aleatórios, recebendo como parâmetro um fator de escala. O fator de escala 1 carrega todas as tabelas com um número reduzido de tuplas cada uma. O fator de escala 2, carrega as tabelas com o dobro de tuplas do fator de escala 1 e assim por diante. Inclua no relatório os comandos SQL de criação e invocação do procedimento.</a><br>
<a>• Implemente uma visão computada e uma visão materializada no esquema e implemente consultas que utilizem tais visões e atualizações que afetem o seu conteúdo. Inclua as instruções SQL no relatório.</a><br>
<a>• Com relação a CTE (Common Table Expressions), implemente uma consulta não recursiva que utilize a cláusula WITH e uma consulta recursiva usando WITH RECURSIVE. Lembrando que consultas com WITH devem considerar seus usos típicos, como uma subconsulta relativamente complexa utilizada mais de uma vez na consulta externa ou por uma questão clara de legibilidade. Evite utilizar WITH quando uma junção simples resolve o problema. Inclua no relatório uma descrição do que cada uma das consultas retorna e a instrução SQL correspondente.</a><br>
<a>• Implemente duas consultas utilizando Window Functions que façam sentido para o banco de dados. Inclua no relatório a descrição das consultas, a instrução SQL e algumas tuplas do resultado que ilustrem o que a consulta retorna.</a><br>
<a>• Implemente uma função SQL que faça sentido para o banco de dados e uma consulta que a invoca. Inclua ambas no relatório.</a><br>
<a>• Implemente um trigger DML faça uma atualização automática (e.g., log de atualizações, tabela de histórico, manutenção de atributo derivado, etc.) e uma restrição de integridade complexa implementada via triggers, lançando uma exceção caso a restrição seja violada (a restrição pode demandar um ou mais triggers, dependendo da sua lógica). Inclua no relatório as instruções de criação dos triggers, instruções que disparam os triggers (e.g., INSERT, DELETE e/ou UPDATE) e consultas que mostram o resultado da execução dos triggers (e.g., consulta da(s) tabela(s) atualizada(s) automaticamente pelo trigger e atualização que viole a restrição de integridade implementada no(s) trigger(s)).</a>
</div>
