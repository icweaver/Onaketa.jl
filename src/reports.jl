function generate_report(num, row)
    @mdx """<h3>$(num)) $(row.student_name)</h3>

    !!! note " "
        [**Schedule**]($(row.schedule))

        **Grade:** $(row.student_grade)

        **Age:** $(row.student_age)

        **Race/ethnicity:** $(row.student_race_ethnicity)

        **Household size:** $(row.house_size)

        **State:** $(row.student_state)

        **Course subject:** $(row.course_subject)

        **Course name:** $(row.course_name)

        **Performance:** $(row.question_performance)

        **Strengths:** $(row.question_strengths)

        **Struggles:** $(row.question_struggles)

        **Goals:** $(row.question_goals)

        **Other questions:** $(row.question_other)
    """
end;
