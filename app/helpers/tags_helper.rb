module TagsHelper
  MAIN_CATEGORIES = {
    'Life' => ['Adoption', 'Children', 'Elder Care', 'Fatherhood', 'Motherhood', 'Aging', 'Coronavirus', 'Covid-19',
               'Death And Dying', 'Disease'],
    'Self Improvement' => ['Anxiety', 'Counseling', 'Grief', 'Life Lessons', 'Self-awareness', 'Career Advice',
                           'Coaching', 'Goal Setting', 'Morning Routines', 'Pomodoro Technique'],
    'Work' => ['Entrepreneurship', 'Freelancing', 'Small Business', 'Startups', 'Venture Capital', 'Advertising',
               'Branding', 'Content Marketing', 'Content Strategy', 'Digital Marketing'],
    'Technology' => ['JavaScript', 'Python', 'Ruby', 'Java', 'C#', 'PHP', 'TypeScript', 'Swift', 'Kotlin', 'Go',
                     'HTML', 'CSS', 'React', 'Angular', 'Vue.js', 'Node.js', 'Django', 'Flask', 'Ruby on Rails', 'ASP.NET'],
    'Databases' => %w[MySQL PostgreSQL MongoDB SQLite Redis Firebase Cassandra],
    'DevOps' => ['Docker', 'Kubernetes', 'Jenkins', 'CI/CD', 'AWS', 'Azure', 'Google Cloud', 'Terraform'],
    'Development Practices' => ['Agile', 'Scrum', 'TDD (Test-Driven Development)', 'BDD (Behavior-Driven Development)',
                                'Pair Programming', 'Continuous Integration', 'Continuous Deployment'],
    'Version Control' => %w[Git GitHub GitLab Bitbucket],
    'IDEs' => ['Visual Studio Code', 'IntelliJ IDEA', 'PyCharm', 'WebStorm', 'Sublime Text', 'Vim', 'Emacs'],
    'Mobile Development' => ['Android', 'iOS', 'Flutter', 'React Native', 'SwiftUI', 'Kotlin Multiplatform'],
    'Data Science' => ['Pandas', 'NumPy', 'TensorFlow', 'PyTorch', 'Scikit-Learn', 'Keras', 'Jupyter Notebook', 'R'],
    'Cybersecurity' => ['Encryption', 'Penetration Testing', 'Vulnerability Assessment', 'Firewalls',
                        'Network Security', 'Ethical Hacking', 'OWASP']
  }.freeze

  def self.categorized_tags
    MAIN_CATEGORIES
  end

  def main_categories
    MAIN_CATEGORIES.keys
  end

  def tags_for_category(category)
    MAIN_CATEGORIES[category] || []
  end
end
